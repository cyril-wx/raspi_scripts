#!/bin/bash
# 网络重连脚本

# 获取当前脚本运行目录
basepath=$(cd `dirname $0`; pwd)
# 获取当前时间
cdate=`date`
# 获取wlan0网卡信息
info=`ifconfig wlan0`
# 检查当前WLAN0网络IP
wlan0_ip=`echo $info | awk -F "inet" '{print $2}' | awk -F " " '{print $1}'`
echo $wlan0_ip


[[ `curl -I -s --connect-timeout 30 www.163.com -w %{http_code} | tail -n1` == "200" ]] && echo "[$cdate]: Network is connected..." || /usr/bin/python3 /root/SD_net_auto_login.py >> $basepath/SD_net_auto_login.log

sleep 1

# 运行第二遍
[[ `curl -I -s --connect-timeout 30 www.163.com -w %{http_code} | tail -n1` == "200" ]] && echo "[$cdate]: Network is connected..." || /usr/bin/python3 /root/SD_net_auto_login.py >> $basepath/SD_net_auto_login.log

sleep 1
