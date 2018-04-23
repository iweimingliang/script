#!/bin/bash


ping_time=`date -d day +%Y%m%d-%H:%M:%S`

while read line
do
   echo "--------------------$ping_time---------------------">>$line.log
                               
   ping $line -A -c 100 |grep packet >>$line.less
   ping $line -A -c 100 |grep rtt >>$line.ms
   echo "---------------------------------------------------">>$line.log
done < ip_list
