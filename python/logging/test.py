import logging
#-*- coding:utf-8 –*-
import logging
from logging.handlers import RotatingFileHandler
#定义一个RotatingFileHandler，最多备份5个日志文件，每个日志文件最大10M
Rthandler = RotatingFileHandler('myapp.log', maxBytes=0.1*1024*1024,backupCount=5)
Rthandler.setLevel(logging.INFO)
formatter = logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s')
Rthandler.setFormatter(formatter)
logging.getLogger('').addHandler(Rthandler)

logging.debug('debug 日志信息')
logging.info('info 日志信息')
logging.warning('warning 日志信息')
logging.error('error 日志信息')  
logging.critical('critical 日志信息') 
