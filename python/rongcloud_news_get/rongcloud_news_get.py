#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging    
import logging.config
import urllib3
import os
import time
import datetime
import random
import hashlib
import json
from sendmail import sendmail
     

def get_log_url(url,AppKey,House):
    Nonce = random.randrange(0,100000)
    Timestamp = str(time.time()).split('.')[0]
    Yesterday = str((datetime.datetime.now()-datetime.timedelta(days=1)).strftime("%Y%m%d")) + House

    data = 'xxxx' + str(Nonce) + str(Timestamp)
    Signature =  hashlib.sha1(data).hexdigest()
        
    http = urllib3.PoolManager()

    r = http.request(
        'POST',
        url,
        headers = {
            'App-Key':AppKey,
            'Nonce':Nonce,
            'Timestamp':Timestamp,
            'Signature':Signature,
        },
        fields = {
            'date':Yesterday,
        },
        timeout = 4.0,
        retries = 5,
    )
    r.release_conn()
    return r.data

def get_news_log(log_url,filename):
    news_filename = str(filename)
    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)
    if not os.path.exists(script_dir+'/newsdata'):os.makedirs(script_dir+'/newsdata')

    http = urllib3.PoolManager()
#    print log_url
    r = http.request(
        'GET',
        log_url,
        timeout = 4.0,
        retries = 5,
    )
    with open(script_dir + '/newsdata/' + news_filename + '.zip', 'wb') as f:
        f.write(r.data)
    
    log_news = news_filename + ' Download historical success stories'
    info_log.info(log_news)

    r.release_conn()
    return r.status

   
       
if __name__ == '__main__':
    error_num = 0
    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)

 
    #判断日志文件目录是否存在,不存在则创建
    if not os.path.exists(script_dir+'/logs'):os.makedirs(script_dir+'/logs')

    #读写日志配置文件
    logging.config.fileConfig(script_dir + "/logging.conf")

    #示例日志
    info_log = logging.getLogger("info")
    error_log = logging.getLogger("error")

    #打印启动信息到info日志
    info_log.info("----------融云历史消息下载程序启动----------")

    
    url = 'http://api.cn.ronghub.com/message/history.json'
    AppKey = 'xxxx'

    for i in range(0,24):
        b = str(i).zfill(2)
        a = json.loads(get_log_url(url,AppKey,b))
        if a['code'] == 200:
           if a['url'] == "": 
               log_news = str(a['date'] + ' This document url is empty')
               error_log.error(log_news)
               error_num = error_num + 1
           else:
               get_news_log(a['url'],a['date'])
        else:
            Yesterday = str((datetime.datetime.now()-datetime.timedelta(days=1)).strftime("%Y%m%d")) + b
            log_news = Yesterday + str(a['code']) + ' ' + a['errorMessage']
            error_log.error(log_news)
            error_num = error_num + 1
  
    info_log.info("----------消息下载完成，开始发送邮件----------")

    #发送邮件
    from_addr = 'adminNotice@xiu8.com'  
    password = 'adminxiu82018'
    to_address = 'xiaowen@xiu8.com'
    smtp_server = 'mail.xiu8.com'
    sender = '发件人 <adminNotice@xiu8.com>'    
    recipients = '收件人 <xiaowen@xiu8.com>'
    subject = '融云历史消息下载，错误数 ' + str(error_num)
    content = '融云历史消息下载，错误数 ' + str(error_num)
    attach_addr = '/root/github/python_script/sendmail/defa_attach.txt'
    sendmail.Send_mail(from_addr,password,to_address,smtp_server,sender,recipients,subject,content,attach_addr)

    info_log.info("----------融云历史消息下载程序结束----------")
