# 日志处理函数
function logs(){
   datetime=$(date)
   mkdir -p $basepath/logs;
   echo $datetime $@ 2>&1 >> $basepath/logs/info.log
   echo $datetime $@ 2>&1 >> $basepath/logs/$stream_name.log
}

function help(){
    echo -e "\033[44m帮助:\033[0m"
    echo -e "\033[42m使用方式:\033[0m"
    echo "    $0 stream_url"
    echo "    stream_url 为流地址"
    echo -e "\033[45m示例:\033[0m"
    echo "    $0 "
    echo "    stream_url http://void.2cq.com/liverepeater/932539.flv"
    echo " "
}

# 主函数
function main(){
    # 获取程序所在地址
    basepath=$(cd `dirname $0`; pwd)


    logs "---------- start ----------"

    # 判断是否查看帮助
    if [[ $1 == '-h' ]];then
        help
        exit 1
    fi 

    # 判断传递的参数是否正确
    if [[ $# != 2 ]];then
        echo -e "\033[41mError:缺少参数!\033[0m"
        echo ""
        help
        exit 1
    fi

    project=$1
    program=$2

    # 记录项目和程序
    logs "project:" $project "program:" $program
    
    logs "---------- end ----------"
}

# 程序入口
main "$@"
