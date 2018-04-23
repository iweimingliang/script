#!/bin/bash

riqi=`date -d -35day +%Y.%m.%d`
log_riqi=`date +%Y%m%d-%H:%M:%S`
DIR="$( cd "$( dirname "$0"  )" && pwd)"
LOG="$DIR/cluster_status.log"
ip='x.x.x.x'
chengxuip='x.x.x.x'
port='x.x.x.x'

cluster_status=`curl -s -XGET http://$ip:$port/_cluster/health?pretty|grep status|awk -F '"' '{print $4}'`

if [ ! -n "$cluster_status" ];then
     echo "$cluster_status" >>$LOG
     echo "$log_riqi" >>$LOG
     echo "elshead连接不到集群请检查集群" >>$LOG
     echo "------------------------------" >>$LOG
    /usr/bin/python $DIR/sendmail/sendmail.py "elshead集群连接错误" "集群连接错误，请检查。程序运行地址:$chengxuip"
        
elif [ $cluster_status == 'green' ];then
    echo "$cluster_status" >>$LOG
    echo "$log_riqi" >>$LOG
    echo "elshead集群运行正常" >>$LOG
    echo "------------------------------" >>$LOG
    /usr/bin/python $DIR/sendmail/sendmail.py "elshead集群运行正常" "elshead集群运行正常.集群状态为:$cluster_status.程序运行地址:$chengxuip"
else
    echo "$cluster_status" >>$LOG
    echo "$log_riqi" >>$LOG
    echo "elshead集群状态有问题，请检查" >>$LOG
    echo "------------------------------" >>$LOG
     /usr/bin/python $DIR/sendmail/sendmail.py "elshead集群状态有问题" "elshead集群状态有问题.集群状态为:$cluster_status.程序运行地址:$chengxuip"
fi
