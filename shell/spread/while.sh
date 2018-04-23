#!/bin/bash


while read filename
do
    b=`echo $filename|awk '{print $3}'`
    a=`curl -I "$b"|grep Location`
#    sp_pid=`echo $filanme|awk -F "?" '{print $2}'|awk -F "=" '{print $2}' |awk -F "&" '{print $1}'`
    sp_pid=`echo $filename|awk -F "=" '{print $2}'|awk -F "&" '{print $1}'`
    sp_sid=`echo $filename|awk -F "=" '{print $3}'`
    sp_apk=${sp_pid}${sp_sid}
    apk_pid=`echo $a|awk -F "-" '{print $3}'`
    apk_sid=`echo $a|awk -F "-" '{print $4}'`
    apk_apk=`echo $a|awk -F "-" '{print $5}'|awk -F "." '{print $1}'`
#    echo $sp_pid
#    echo $sp_sid
#    echo $sp_apk
#    echo $apk_pid
#    echo $apk_sid
#    echo $apk_apk
#    echo $filename 
#    echo $a
    if [ $sp_pid != $apk_pid ];then 
       echo "--------"
       echo $sp_pid
       echo $filename
       echo "---"
       echo $apk_pid
       echo $a
       echo "--------"
    else 
        if [ $sp_sid != $apk_sid ];then
            echo "--------"
            echo $sp_sid
            echo $filename
            echo "---"
            echo $apk_sid
            echo $a
            echo "--------"

        else
            if [ $sp_apk != $apk_apk ];then
                echo "--------"
                echo $sp_apk
                echo $filename
                echo "---"
                echo $apk_apk
                echo $a
                echo "--------"

            fi
        fi
    fi



done < spread.txt
