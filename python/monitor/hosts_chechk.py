#!/usr/bin/env python

import os  
  
status = os.system("ping -c 5 -A www.baidu.com");  

print status
  
if status == 0:  
    print 'ok';  
else:  
    print 'faild';  
