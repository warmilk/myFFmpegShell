#!/bin/bash
# get all filename in specified path

# shell中的分隔符默认是空格或制表符，由环境变量IFS指定，我们这里遍历的文件名是包含空格的
# 参考 https://blog.csdn.net/xiejianjun417/article/details/121889216
oldIFS=$IFS
IFS=$'\n'

rm ./filelist.txt
path=. #.是当前文件夹的意思
files=$(ls $path)
for filename in $files
do
   str=\' #\'是单引号的意思，前面拼接成功了，记得更新grep的正则表达式
   echo "file '"$filename$str | grep "mp4${str}$" >> filelist.txt
done


IFS=$oldIFS