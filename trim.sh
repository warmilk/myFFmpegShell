#!/bin/bash
#参考 https://www.csdn.net/tags/MtTaEgysNDI0NTE3LWJsb2cO0O0O.html
#我这里要切除的开头是 0 秒 ， 结尾是 4 秒
beg=0
end=4
dirname=result #存放结果的文件夹名字

if [ -d ./$dirname ];then
    rm -rf $dirname
    echo "旧文件夹已清除"
    mkdir $dirname
    echo "创建文件夹成功"
else
    mkdir $dirname
    echo "新建文件夹成功"
fi


#用 for 循环直接获取当前目录下的 mp4、mp3、avi 等文件循环处理，单个文件可以去掉 for 循环
for i in *.mp4; do
	#将元数据信息临时保存到 tmp.log 文件中
    nohup ffmpeg -i "$i" > ./tmp.log
    #获取视频的时长，格式为  00:00:10,10 （时：分：秒，微妙）
    time="`cat ./tmp.log |grep Duration: |awk  '{print $2}'|awk -F "," '{print $1}'|xargs`"
    echo $time
    #求视频的总时长，先分别求出小时、分、秒的值，这里不处理微秒，可以忽略
    hour="`echo $time |awk -F ":" '{print $1}' `"
    min="`echo $time |awk -F ":" '{print $2}' `"
    sec="`echo $time |awk -F ":" '{print $3}'|awk -F "." '{print $1}' `"
    #echo $hour $min $sec
    num1=`expr $hour \* 3600`
    num2=`expr $min \* 60`
    num3=$sec
    #计算出视频的总时长（秒）
    sum=`expr $num1 + $num2 + $num3`  
    
    #总时长减去开头和结尾就是截取后的视频时长,并且这里不需要再转回 hour:min:sec 的格式，直接使用结果即可
    newtime=`expr $sum - $beg - $end`
    echo $newtime
    ffmpeg -ss 00:00:00 -i $i -t $newtime -c:v copy -c:a copy ./result/$i -y
    rm ./tmp.log
done