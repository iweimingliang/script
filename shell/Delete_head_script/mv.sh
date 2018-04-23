#!/bin/bash

filename=`date "+%Y%m%d"`
local_ip=`python get_ip.py`
path='/path'
date_time=`date "+%Y%m%d %H:%M:%S:%N"`
sub="head delete program running"
content="$local_ip $date_time  Head remove programs already in operation or to delete the text does not exist"


function pid()
{
    if [ ! -f "$path/$filename.txt" -o -f "/tmp/script/$filename.pid" ];then
#        echo "yaofasongyoujian"
        python sendmail.py "$sub" "$content"
#        echo "$local_ip tou xiang shan chu huan zai yunxing"
        echo 0
    else
#        echo "$filename.pid"
        echo "$filename" >> $filename.pid
        echo 1
    fi     
} 
function Delete_head()
{
    find /tmp/touxiang/*  -exec rm -rf {} \;
}
function mv_head_img()
{
    cat $path/$filename.txt| while read line_file
    do
        line=`echo $line_file|tr -d "\r"`
        a1=`echo $line |awk -F '/' '{print $1}'`
        a2=`echo $line |awk -F '/' '{print $2}'`
        a3=`echo $a1/$a2`
        echo "$date_time " >> /tmp/script/filelist.log
        echo $a3  >> /tmp/script/filelist.log
        echo $line >> /tmp/script/filelist.log
        if [ ! -d /tmp/touxiang/b/1_1/$a3 ]; then
           mkdir -p /tmp/touxiang/b/1_1/$a3 
           mkdir -p /tmp/touxiang/s/1_1/$a3 
           mkdir -p /tmp/touxiang/m/1_1/$a3 
           mkdir -p /tmp/touxiang/b/4_3/$a3 
           mkdir -p /tmp/touxiang/s/4_3/$a3 
           mkdir -p /tmp/touxiang/m/4_3/$a3 
        fi
        mv /path/avatar/b/1_1/$line /tmp/touxiang/b/1_1/$a3/
        mv /path/avatar/b/4_3/$line /tmp/touxiang/b/4_3/$a3/
        mv /path/avatar/m/1_1/$line /tmp/touxiang/m/1_1/$a3/
        mv /path/avatar/m/4_3/$line /tmp/touxiang/m/4_3/$a3/
        mv /path/avatar/s/1_1/$line /tmp/touxiang/s/1_1/$a3/
        mv /path/avatar/s/4_3/$line /tmp/touxiang/s/4_3/$a3/
    done
}
File_exists=`pid`
if [  $File_exists == 0 ];then
    echo "$date_time  Head remove programs already in operation or to delete the text does not exist" >>/tmp/script/head_delete.log
else
    Delete_head 
    mv_head_img
    rm -f /tmp/script/$filename.pid
#    echo "/tmp/script/$filename.pid"
    mv $path/$filename.txt /tmp/touxiang/
fi
