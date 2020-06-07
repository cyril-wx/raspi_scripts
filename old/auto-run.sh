#!/bin/bash

# 脚本当前路径
basepath=$(cd `dirname $0`; pwd)
res=""

getCurrentIP(){
        # 获取wlan0网卡信息
        info=`ifconfig wlan0`
        # 检查当前WLAN0网络IP
        wlan0_ip=`echo $info | awk -F "inet" '{print $2}' | awk -F " " '{print $1}'`
        echo $wlan0_ip
}
getCurrentIP_eth0(){
        info=`ifconfig wlan0`
        eth0_ip=`echo $info | awk -F "inet" '{print $2}' | awk -F " " '{print $1}'`
        echo $eth0_ip
}

while ((1))
do
        cdate=`date`
        [[ `curl -I -s --connect-timeout 30 www.163.com -w %{http_code} | tail -n1` == "200" ]] && res="True" || res="False"
        if [  $res != "True" ]; then
                echo "Network Error->"
                echo $cdate >> $basepath/auto-run.log
                echo "Network is in exception, reconnecting(network/ntpdate/send-ip-mail/phddns/nginx)..." >> $basepath/auto-run.log
                # 重启网卡
                # systemctl restart network
                ifdown eth0, wlan0
                ifup eth0, wlan0
                sleep 5

                wlan0_ip=`getCurrentIP`
                # 将ip写入临时文档以备检查
                echo $wlan0_ip > /tmp/auto-run.tmp
                if [[ $wlan0_ip =~ "10.135" ]] ; then
                        echo "Current is SmartDomain net, will auto login." >> $basepath/auto-run.log
                        /root/SD_net_reconnect.sh  # 如果连的是宿舍网，则运行自动登录脚本
                fi
                /usr/sbin/ntpdate pool.ntp.org
                /root/send-ip-mail.sh
                /usr/sbin/phddns stop
                /usr/sbin/phddns start
                /usr/bin/systemctl stop pyserver
                /usr/bin/systemctl start pyserver
#               /usr/local/bin/nginx -s reload
                /usr/local/bin/nginx stop
                /usr/local/bin/nginx start
                echo $cdate >> $basepath/auto-run.log
                # 网络重启成功 则继续，否则 退出。
                if [ $? -eq 0 ]; then
                        echo "Reconnecting(network/ntpdate/send-ip-mail/phddns) successful..." >> $basepath/auto-run.log
                else
                        echo "Reconnecting(network/ntpdate/send-ip-mail/phddns) failed, waiting 10min to reconnection..." >> $basepath/auto-run.log
                fi
        else
                echo $cdate >> $basepath/auto-run.log
                echo "Network is normal. I will check it after 10min later." >> $basepath/auto-run.log
                WLAN0_IP_ADDR=`getCurrentIP`
                [[ $WLAN0_IP_ADDR == `cat /tmp/auto-run.tmp` ]] && echo "IP is not changed" || ( echo "IP is changed" ; /root/send-ip-mail.sh )
                echo $WLAN0_IP_ADDR > /tmp/auto-run.tmp
        fi

        sleep 300
done
