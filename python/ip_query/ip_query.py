#!/usr/bin/python
# -*- coding: utf-8 -*-
#python3

import httplib2, urllib
import sys,os
import json


def ipquery(ip):
#    print ip
    params = urllib.urlencode({'ip':ip,'datatype':'jsonp','callback':'find'})
    url = 'http://api.ip138.com/query/?'+params
    headers = {"token":"367deeb5d79e91b687101656932d53d5"}#token为示例
    http = httplib2.Http()
    response, content = http.request(url,'GET',headers=headers)
    print(content)

ip_file = open(os.path.split(os.path.realpath(sys.argv[0]))[0] + '/ip_list.conf')
for i in ip_file.readlines():
#    print i.strip()
    ipquery(i.strip()) 
ip_file.close()
