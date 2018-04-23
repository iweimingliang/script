#!/usr/bin/env python
# -*- coding: utf-8 -*-
#version 1.0 and python2

import os
import sys
import datetime

word_dict = {}

def fenxi(filename,complete_file):
    word_file = open(filename)
    complete_filename = open(complete_file,'w')
    for i in word_file.readlines():
        line_list =  i.strip().split()
        for j in range(len(line_list)):
           k = filter(str.isalpha,line_list[j]).lower() 
           if len(k.strip()) == 0 or len(k.strip()) == 1 or len(k.strip()) > 12:
               continue
           else:
               if word_dict.has_key(k):
                   word_dict[k] = word_dict[k] + 1;
               else:
                   word_dict[k] = 1;
#               complete_filename.write(k)
    #    print filter(str.isalpha,i.strip()) 
    #    print i.strip().lstrip().rstrip(',')
    word_file.close()
    for i in sorted(word_dict.iteritems(), key=lambda word_dict:word_dict[1], reverse = True):
        sort_content = i[0] + " " + str(i[1]);
        complete_filename.write(sort_content)
        complete_filename.write("\n")
    complete_filename.close()

def Arrangement(complete_file,yibei_file,weibei_file):
    yibeilist = []
    t = 0;
    conmpletefile = open(complete_file) 
    yibeifile = open(yibei_file) 
    weibeifile = open(weibei_file,'w') 
    for i in yibeifile.readlines():
        yibeilist.append(i.strip())
    yibeifile.close()

    shijian = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    weibeifile.write(shijian)
    weibeifile.write("\n")

    yibeifile = open(yibei_file,'a') 
    yibeifile.write(shijian)  
    yibeifile.write("\n")  
    for i in conmpletefile.readlines(): 
        j = i.split()
        if j[0] in yibeilist:
            pass;
        else:
            weibeifile.write(j[0])  
            weibeifile.write("\n")  
            yibeifile.write(j[0])  
            yibeifile.write("\n")  
            t = t + 1;
            if t == 5:break;
   
    conmpletefile.close()
    yibeifile.close()
    weibeifile.close()

word_file = os.path.split(os.path.realpath(sys.argv[0]))[0] + '/' + 'movie.butijiao'
complete_file = os.path.split(os.path.realpath(sys.argv[0]))[0] + '/' + 'complete.butijiao'
yibei_file = os.path.split(os.path.realpath(sys.argv[0]))[0] + '/' + 'yibei.butijiao'
weibei_file = os.path.split(os.path.realpath(sys.argv[0]))[0] + '/' + 'weibei.butijiao'
#print complete_file
#print word_file
fenxi(word_file,complete_file);
Arrangement(complete_file,yibei_file,weibei_file);
