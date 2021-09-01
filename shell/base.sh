#!/bin/bash

# 日志处理函数
function logs(){
   datetime=$(date)
   echo $datetime $@ 2>&1 >> /opt/app/jenkins/logs/ProgramVersionCreate.log 
}

function help(){
    echo "示例:"
    echo "    $0 project program"
    echo "    project为项目名称 program为日志名称"
    echo " "
    echo "error code:"
    echo "    1:缺少参数"
    echo "    2:程序日志不存在"
}

# 主函数
function main(){
    logs "---------- start ----------"

    # 判断是否查看帮助
    if [[ $1 == '-h' ]];then
        help
        exit 1
    fi 

    # 判断传递的参数是否正确
    if [[ $# != 2 ]];then
        echo "1"
        exit 1
    fi

    project=$1
    program=$2

    # 记录项目和程序
    logs "project:" $project "program:" $program

    # 生成程序日志路径
    program_log="/opt/app/jenkins/logs/""$project/""$program.log"
    logs "program log:" $program_log
  
    echo $program_log

    if [[ -f $program_log ]];then
        echo "ok"
    else
        echo "2"
        logs "$program_log" "not fonud."
    fi
    
    logs "---------- end ----------"
}

# 程序入口
main "$@"
