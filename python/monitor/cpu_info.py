#!/usr/bin/env python

import psutil

def cpu_info_get():
    cpu_info_dict = {} 
#    cpu_info_dict = {'user':0.0, 'nice':0.0, 'system':0.0, 'idle':100.0, 'iowait':0.0, 'irq':0.0, 'softirq':0.0, 'steal':0.0, 'guest':0.0, 'guest_nice':0.0} 

    cpu_info = psutil.cpu_times_percent(interval=0.1, percpu=False)
    cpu_info_dict['user'] = cpu_info.user
    cpu_info_dict['nice'] = cpu_info.nice
    cpu_info_dict['system'] = cpu_info.system
    cpu_info_dict['idle'] = cpu_info.idle
    cpu_info_dict['iowait'] = cpu_info.iowait
    cpu_info_dict['irq'] = cpu_info.irq
    cpu_info_dict['softirq'] = cpu_info.softirq
    cpu_info_dict['steal'] = cpu_info.steal
    cpu_info_dict['guest'] = cpu_info.guest
    cpu_info_dict['guest_nice'] = cpu_info.guest_nice

    return cpu_info_dict
   



if __name__ == '__main__':
#    cpu_info_dict = {}
    cpu_info_dict = cpu_info_get()
    for key,value in cpu_info_dict.items():
        print key,value   
 
