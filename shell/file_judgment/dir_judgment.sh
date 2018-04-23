#!/bin/bash

if [ ! -n "$1" ];then
    echo "请输入目录路径"
    echo "示例：./file_judgment.sh 1"
    exit
fi

FILE_PATH=$1

if [ -d "$FILE_PATH" ];then
    echo "$FILE_PATH 存在"
   else
    echo "$FILE_PATH 不存在"
fi
