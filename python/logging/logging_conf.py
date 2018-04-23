#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging    
import logging.config
import os
     

class init_logs():
    def __init__ (self):
        script_path = os.path.realpath(__file__)
        script_dir = os.path.dirname(script_path)

        if not os.path.exists(script_dir+'/logs'):os.makedirs(script_dir+'/logs')

        logging.config.fileConfig("logging.conf")   

        self.info_log = logging.getLogger("info")    
        self.error_log = logging.getLogger("error")  

    def info(self,info_news):
        self.info = info_news
        self.info_log.info(self.info)    

    def error(self,error_news):
        self.error = error_news
        self.error_log.error(self.error) 

if __name__ == '__main__':
    log = init_logs();
    log.info("葫芦王")
    log.error("精钢葫芦娃")

