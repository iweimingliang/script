#!/bin/bash

#获取脚本所在目录
date_time=$(date +%Y%m%d-%H%M)
basepath=$(cd `dirname $0`; pwd)
INSTALL_LOG=install_$date_time.log
LOG_NAME=init_$date_time.log


# 日志处理函数
function logs(){
   datetime=$(date)
   echo $datetime $@ 2>&1 >> $LOG_NAME
}

function install_logs(){
   datetime=$(date)
   echo $datetime $@ 2>&1 >> $INSTALL_LOG 
}

# 配置dns
function dns_config(){
  # 配置dns
  echo "dns-config"
  echo "nameserver 224.5.5.5" >/etc/resolv.conf;echo "nameserver 114.114.114.114" >>/etc/resolv.conf

  # 检查
  dns_check=$(grep -E '223.5.5.5|114.114.114.114'  /etc/resolv.conf); 
  if [[ dns_check > 0 ]];then 
    logs 'dns-config-ok' 
  else
    logs 'dns-config-error' 
 
  fi
}    

# yum安装epcl扩展
function yum_config(){
    # yum安装epcl扩展
    echo "yum-epel-config"
    yum install epel-release -y 2>&1 >> $INSTALL_LOG

    # 检查
    if [ $? == 0 ];then 
       logs  'yum-config-ok' 
    else
       logs  'yum-config-error' 
    fi;

} 

# 常用工具安装
function tools_install(){
    # 常用工具安装
    echo "tools-install"
    yum install net-tools wget net-snmp lrz* unzip patch rsync ntp iptables* -y 2>&1 >> $INSTALL_LOG
    # 检查
    if [ $? == 0 ];then 
        logs  'software-config-ok'
    else
        logs  'software-config-error'
    fi

}


# 配置时间同步
function time_sync_config(){
    # 配置定时任务
    echo "time-sync-config"
    echo '*/10 * * * * /usr/sbin/ntpdate time.windows.com > /dev/null 2>&1' >/var/spool/cron/root

    # 检查
    if [ $? == 0 ];then 
        logs  'time-sync-config-ok' 
    else
        logs  'time-sync-config-error' 
    fi
}

# 配置hostnmae
function hostname_config(){
    # ip配置
    echo "hostname-config"
    ipdi=$(ifconfig  | grep 'netmask'| grep -v '127.0.0.1' |awk '{print $2}') && mowei=$(echo $ipdi|awk -F "." '{print $4}') && sanwei=$(echo $ipdi|awk -F "." '{print $3}');name="hostname";mowei=${sanwei}"-"${mowei} && hostname $name-$mowei && echo "$name-$mowei">/etc/hostname && sed -i "/$ipdi/d" /etc/hosts && echo "$ipdi  $name-$mowei">>/etc/hosts

    # 检查
    if [ $? == 0 ];then 
        logs  'hostname-config-ok'
    else
        logs  'hostname-config-error'
    fi
}

# 配置snmp
function snmp_config(){
    # 配置
    echo "snmp-config"
    echo -e "rocommunity public\nsyslocation yungu\nsyscontact test@test.com\nproxy   -v 2c -c public 127.0.0.1:1161 .1.3.6.1.4.1.42" > /etc/snmp/snmpd.conf 2>&1 >> $INSTALL_LOG

    echo 'OPTIONS="-LS3d -Lf /dev/null -p /var/run/snmpd.pid"' >>/etc/sysconfig/snmpd 

    systemctl enable snmpd;systemctl start snmpd;

    # 检查
    if [ $? == 0 ];then 
        logs 'snmpd-config-ok';
    else
        logs 'snmpd-config-error';
    fi
}

# 添加普通用户
function user_add(){
    echo "useradd-config"
    useradd mingliang;echo 'passwd' | passwd --stdin mingliang 2>&1 >> $INSTALL_LOG

    # 检查
    useradd_check=$(grep -E 'mingliang'  /etc/passwd); 

    if [[ useradd_check > 0 ]];then 
        logs 'useradd-config-ok' 
    else
        logs 'useradd-config-error' 
    fi
}

# 禁止root通过ssh直接登陆
function root_ssh_nologin(){
    echo "root-ssh-nologin-config"
    a=`date "+%Y%m%d"`;
    mkdir -p /home/bak/$a

    cp /etc/ssh/sshd_config /home/bak/$a/
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

    # 检查
    root_ssh_check=$(grep -E 'PermitRootLogin no'  /etc/ssh/sshd_config); 
    
    if [[ root_ssh_check > 0 ]];then 
        logs 'root-ssh-nologin-config-ok' 
    else
        logs 'root-ssh-nologin-config-error' 
    fi
}

# 关闭selinux,并设置为开机不启动
function disable_selinux(){
    echo "selinux-config"
    setenforce 0
    sed -i 's/enforcing/disabled/' /etc/selinux/config 
    
    # 检查
    selinux_check=$(grep -E 'disabled'  /etc/selinux/config); 

    if [[ selinux_check > 0 ]];then 
        logs 'selinux-config-ok' 
    else
        logs 'selinux-config-error' 
    fi
}

# 配置防火墙
function firewalld_off(){
    echo "firewalld-off"
    systemctl stop firewalld.service;systemctl disable firewalld.service 

    # 检查
    if [ $? == 0 ];then 
        logs  'firewalld-off-ok'
    else
        logs  'firewalld-off-error'
    fi
}

# 关闭ipv6  
# ipv6-off
function ipv6_off(){
    echo "ipv6-off"
    sed -i 's/crashkernel/ipv6.disable=1 crashkernel/' /etc/default/grub;grub2-mkconfig -o /boot/grub2/grub.cfg 2>&1 >> $INSTALL_LOG

    # 检查
    ipv6_off_check=$(grep -E 'ipv6.disable=1'  /etc/default/grub); 
    
    if [[ ipv6_off_check > 0 ]];then 
        logs 'ipv6-off-ok' 
    else
        logs 'ipv6-off-error' 
    fi
}

# 优化内核参数
function sysctl_config(){
    echo 'sysctl-config'
cat >> /etc/sysctl.conf << EOF
fs.file-max=655350
EOF

    # 检查
    if [ $? == 0 ];then 
        logs  'sysctl-config-ok'
    else
        logs  'sysctl-config-error'
    fi
}

# 更改文件描述符的数量
function file_max(){
    echo 'file-max-config'
    cp /etc/security/limits.conf /home/bak/$a/
cat >> /etc/security/limits.conf << EOF
*                soft    nofile         65536
*                hard    nofile         65536 
EOF
    # 检查
    file_max_check=$(grep -E '65536'  /etc/security/limits.conf); 
    
    if [[ file_max_check > 0 ]];then 
        logs 'file_max-ok' 
    else
        logs 'file_max-error' 
    fi
}


# 更新系统
function update_os(){
    echo "update-os"
#    yum update -y
    echo "更新完成，重启服务器。"
}

# 主函数
function main(){
  echo "centos7_base_init"
  dns_config
  yum_config
  tools_install
  time_sync_config
  hostname_config
  snmp_config
  user_add
  root_ssh_nologin
  disable_selinux
  firewalld_off
  ipv6_off
  sysctl_config
  file_max
  update_os
}

# 程序入口
main "$@"

