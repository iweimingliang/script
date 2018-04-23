#!/bin/bash

function FILE()
{
    if [ -f "$1" ];then
        echo "$FILE_PATH 文件存在,但无执行权限"
    else
        echo "$FILE_PATH 文件不存在"
    fi

}

if [ ! -n "$1" ];then
    echo "请输入文件路径"
    echo "示例：./file_judgment.sh 1"
    exit
fi

FILE_PATH=$1

if [ -x "$FILE_PATH" ];then
       echo "$FILE_PATH 文件存在"
   else
       FILE $FILE_PATH
fi
