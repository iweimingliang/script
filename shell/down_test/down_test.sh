#!/bin/bash

shijian=`date "+%Y%m%d %H%M%S"`

while read filename
do
    shijian=`date "+%Y%m%d %H%M%S"`
    echo "$shijian" >>info.log
    status=`curl -s $filename`
    echo $status >>info.log
    echo "---------------" >>info.log

done < filename_list.txt

