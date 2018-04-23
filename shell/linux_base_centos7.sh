#!/bin/bash
#author:魏鸣亮
#version:1.0.0
#date:20180328
#email:weimingliang_@guanshizhai.net

#关闭selinux,并设置为开机不启动
echo "selinux设置允许，设置为开机不自启"
setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config
 

#关闭centos7防火墙,并设置为开机不启动
echo "关闭firewalld防火墙，并设置为开机不自启"
systemctl stop firewalld.service 
systemctl disable firewalld.service

#安装iptables
echo "安装iptables"
yum install iptables* -y

#安装常用工具
echo "安装net-tools、vim、lrzsz工具包"
yum install net-tools vim lrzsz psmisc  -y

#关闭ipv6
sed -i 's/crashkernel/ipv6.disable=1 crashkernel/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg


#配置hostname
echo "配置hostname"
ipdi=`ifconfig  | grep 'netmask'| grep -v '127.0.0.1' |awk '{print $2}'`;
ip_last=`echo $ipdi|awk -F "." '{print $4}'`;
ip_secondlast=`echo $ipdi|awk -F "." '{print $3}'`;
hostname weimingliang-$ip_secondlast-$ip_last;echo "weimingliang-$ip_secondlast-$ip_last">/etc/hostname;
sed -i "/$ipdi/d" /etc/hosts;echo "$ipdi  weimingliang-$ip_secondlast-$ip_last">>/etc/hosts 
