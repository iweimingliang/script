#!/usr/bin/python 

import sys
import os
import datetime
import shutil
import urllib
import simplejson as json

animation_ver = '1.0.1'  
animation_id = sys.argv[1]    
animation_id_list = animation_id.split('&')   
animation_icon_path = 'xxx'
version_json_path = 'xxx'

bak_path_data=datetime.datetime.now().strftime("%Y%m%d")
bak_path = 'xxx' + bak_path_data + '/'
bak_file_name=datetime.datetime.now().strftime("%Y%m%d-%H:%M:%S.%f")


if not os.path.exists(bak_path):os.makedirs(bak_path)

def animation_icon_down(animation_ver,animation_icon_path,animation_id):
    animation_icon_path = animation_icon_path + animation_ver + '/'
    animation_file = animation_icon_path + animation_id +'.zip'
    url = 'xxx' + animation_ver + '/' + animation_id +'.zip'

    if not os.path.exists(animation_icon_path):os.makedirs(animation_icon_path)
    if os.path.exists(animation_file):
        shutil.move(animation_file,bak_path + animation_id + '.zip' + '-' + bak_file_name)
        urllib.urlretrieve(url,animation_file) 
    else: 
        urllib.urlretrieve(url,animation_file) 
    

def animation_ver_json(animation_ver,version_json_path,animation_id_list):
    shutil.copyfile(version_json_path + 'version.json',bak_path + 'version.json' + bak_file_name)
    

    jsonobject = json.load(file(version_json_path + 'version.json'))
    for i in animation_id_list:
        jsonobject['result']['gifts'][i] = animation_ver
    t = json.dumps(jsonobject,sort_keys=True,indent=2,item_sort_key=None)    
    f = open(version_json_path + 'version.json','w')
    f.write(t)
    f.close() 



if __name__ == '__main__':
    for i in animation_id_list:
        animation_icon_down(animation_ver,animation_icon_path,i)

    animation_ver_json(animation_ver,version_json_path,animation_id_list)


