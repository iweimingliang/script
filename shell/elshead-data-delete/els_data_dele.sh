#!/bin/bash


riqi=`date -d -30day +%Y.%m.%d`
log_riqi=`date +%Y%m%d-%H:%M:%S`
DIR="$( cd "$( dirname "$0"  )" && pwd)"
LOG="$DIR/els_delete.log"
ip='x.x.x.x'
chengxuip='x.x.x.x'
port='xxxx'

#echo $riqi
#echo $0

DIR="$( cd "$( dirname "$0"  )" && pwd)"
index_status=`curl -s "http://$ip:$port/logstash-nginx-access-ann-$riqi/_stats/commit" |awk -F ':' '{print $1}' |awk -F '"' '{print $2}'`
if [ ! -n "$index_status" ];then
#    echo "$index_status"
    echo "$log_riqi" >>$LOG
    echo "$ip $prot 连接失败" >>$LOG
    echo "------------------------------" >>$LOG
    /usr/bin/python $DIR/sendmail/sendmail.py "els_connect_error" "$ip 连接失败。日志请到$chengxuip服务器查看"
elif [ $index_status == 'error' ];then
    echo "$log_riqi" >>$LOG
    echo "$ip $prot logstash-nginx-access-ann-$riqi 索引不存在" >>$LOG
    echo "------------------------------" >>$LOG
    /usr/bin/python $DIR/sendmail/sendmail.py "els_delete_error" "$ip logstash-nginx-access-ann-$riqi 索引不存在.日志请到:$chengxuip服务器查看"
#    echo "$index_status"
elif [ $index_status == '_shards' ];then
    end_status=`curl -s -XDELETE "http://$ip:$port/logstash-nginx-access-ann-$riqi"`
#    end_status=`echo "http://10.0.1.94:9200/logstash-nginx-access-ann-$riqi"`
    if [ ! -n "$end_status" ];then
        echo "$end_status" >>$LOG
        echo "$log_riqi" >>$LOG
        echo "$ip $prot logstash-nginx-access-ann-$riqi $ip elshead数据删除错误。登录$chengxuip服务器查看日志" >>$LOG
        echo "------------------------------" >>$LOG
        /usr/bin/python $DIR/sendmail/sendmail.py "els_delete_error" "$ip elshead 数据删除错误。登录$chengxuip服务器查看日志"
        
    elif [ $end_status == '{"acknowledged":true}' ];then
        echo "$end_status" >>$LOG
        echo "$log_riqi" >>$LOG
        echo "$ip $prot logstash-nginx-access-ann-$riqi 已删除.日志已记录到$chengxuip服务器" >>$LOG
        echo "------------------------------" >>$LOG
        /usr/bin/python $DIR/sendmail/sendmail.py "els_delete_error" "$ip $prot logstash-nginx-access-ann-$riqi 已删除.日志已记录到$chengxuip服务器"
    else
        echo "$end_status" >>$LOG
        echo "$log_riqi" >>$LOG
        echo "$ip $prot logstash-nginx-access-ann-$riqi $ip elshead数据删除错误。登录$chengxuip服务器查看日志" >>$LOG
        echo "------------------------------" >>$LOG
        /usr/bin/python $DIR/sendmail/sendmail.py "els_data_删除成功" "$ip elshead 数据删除错误。登录$chengxuip服务器查看日志"
    fi
fi
