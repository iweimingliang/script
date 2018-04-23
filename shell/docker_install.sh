#!/bin/bash

###关闭防火墙
systemctl stop firewalld
systemctl disable firewalld
systemctl disable firewalld


###关闭swap
swapoff -a 
sed 's/.*swap.*/#&/' /etc/fstab


###
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p /etc/sysctl.conf


###能装docker
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo



yum install -y --setopt=obsoletes=0 docker-ce-17.03.2.ce-1.el7.centos docker-ce-selinux-17.03.2.ce-1.el7.centos

service docker start 
  
systemctl enable docker.service
