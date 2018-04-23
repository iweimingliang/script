#!/usr/bin/env python


import psutil

def Memory_info_get():
    Memory_info_dict = {} 
    Memory_info = psutil.virtual_memory()

    Memory_info_dict['total'] = Memory_info.total
    Memory_info_dict['available'] = Memory_info.available
    Memory_info_dict['percent'] = Memory_info.percent
    Memory_info_dict['used'] = Memory_info.used
    Memory_info_dict['free'] = Memory_info.free
    Memory_info_dict['active'] = Memory_info.active
    Memory_info_dict['buffers'] = Memory_info.buffers
    Memory_info_dict['cached'] = Memory_info.cached
    Memory_info_dict['shared'] = Memory_info.shared
    
    return Memory_info_dict



def Swap_Memory_info_get():
    Swap_Memory_info_dict = {}

    Swap_Memory_info = psutil.swap_memory()

    Swap_Memory_info_dict['total'] = Swap_Memory_info.total
    Swap_Memory_info_dict['used'] = Swap_Memory_info.used
    Swap_Memory_info_dict['free'] = Swap_Memory_info.free
    Swap_Memory_info_dict['percent'] = Swap_Memory_info.percent
    Swap_Memory_info_dict['sin'] = Swap_Memory_info.sin
    Swap_Memory_info_dict['sout'] = Swap_Memory_info.sout

    return Swap_Memory_info_dict

if __name__ == '__main__':
    print Memory_info_get()
    print Swap_Memory_info_get()
