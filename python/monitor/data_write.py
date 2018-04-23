#!/usr/bin/env python  
#-*- coding:utf-8 -*-

import datetime
import cpu_info
import Memory_info
import shutil
import sys
import os

#调用cpu、内存获取脚本
cpu_info_dict = cpu_info.cpu_info_get()
Memory_info_dict = Memory_info.Memory_info_get()
Swap_Memory_info_dict = Memory_info.Swap_Memory_info_get()


#修改显示单位
for key,value in Memory_info_dict.items():
    if key != 'percent':
        Memory_info_dict[key] = str((Memory_info_dict[key]/1024)/1024) + 'M'

#修改显示单位
for key,value in Swap_Memory_info_dict.items():
    if key != 'percent':
        Swap_Memory_info_dict[key] = str((Swap_Memory_info_dict[key]/1024)/1024) + 'M'



path = os.path.split(os.path.realpath(sys.argv[0]))[0] 

#生成时间
Present_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")


#生成html
monitor_file = open(path + '/monitor.html','w')
message = """
<!DOCTYPE html>
<html lang="zh_cn">
<head>
<meta charset="utf-8" />
</head>
<body>
<p>时间 : %s</p>
<p>cpu运行状态 : %s</p>
<p>Memory使用情况 : %s</p>
<p>Swap使用情况 : %s</p>
</body>
</html>"""%(Present_time,cpu_info_dict,Memory_info_dict,Swap_Memory_info_dict)

monitor_file.write(message)
monitor_file.close()

#判断监控文件是否存在
if os.path.exists('/usr/local/project/blog/output/monitor.html'):
    os.remove('/usr/local/project/blog/output/monitor.html')

shutil.move(path + '/monitor.html','/usr/local/project/blog/output/')
