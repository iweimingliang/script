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
    echo "    $0 stream_url 120 932539-202110121706 5000000"
    echo "    stream_url 为流地址 录制时长(秒) 保存文件名 超时时间(微秒) "
    echo -e "    \033[41m录制时长、保存文件名、超时时间可以不设置。录制时长默认为10分钟，文件保存名默认为流名字加当前时间(精确到秒),超时时间默认为5s。\033[0m"
    echo -e "\033[45m示例:\033[0m"
    echo "    $0 "
    echo "    stream_url http://void.test.com/liverepeater/test.flv"
    echo " "
}

function stream_record(){
 
    stream_url=$1
    stream_name=$2
    record_time=$3
    timeout=$4

    # 记录录制内容
    logs "录制信息: url:$stream_url file_name:$stream_name.mp4 录制时间:$record_time 超时时间:$timeout" 
    
    # 开始录制
    ffmpeg -rw_timeout $timeout -t $record_time -i $stream_url -acodec copy -vcodec copy -f flv -y video/$stream_name.mp4 >> $basepath/logs/info.log 2>&1
}

# 主函数
function main(){
    # 获取程序所在地址
    basepath=$(cd `dirname $0`;pwd)
    logs "---------- start ----------"

    # 判断是否查看帮助
    if [[ $1 == '-h' ]];then
        help
        exit 1
    fi 

    # 判断传递的参数是否正确
    if [[ $# < 1 ]];then
        echo -e "\033[41mError:缺少参数!\033[0m"
        echo ""
        help
        exit 1
    fi

    # 获取流地址
    stream_url=$1

    # 默认流名字
    if [[ ! -n $2 ]];then
        # 获取流名字
        date_time=$(date "+%Y%m%d-%H%M%S")
        stream=$(echo $stream_url|awk -F '/' '{print $5}'|awk -F '.' '{print $1}')
        stream_name=$stream-$date_time
    else
        stream_name=$2
    fi
         
    # 默认录制时长
    if [[ ! -n $3 ]];then
        record_time=120
    else
        record_time=$3
    fi



    # 设置超时时间
    if [[ ! -n $4 ]];then
        content_timeout=5000000
    else
        content_timeout=$4
    fi

    stream_record $stream_url $stream_name $record_time $content_timeout 
    logs "---------- end ----------"
}

# 程序入口
main "$@"
