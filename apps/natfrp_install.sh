#!/bin/bash
set -ex
set -o pipefail

## 引入公共变量
. ../utils/variables.sh
# >>>>>引入公共变量
#   path   : 当前运行脚本绝对路径
# <<<<<


########################################
# 安装natfrp(树莓派专用32/64位)
#--------------------------------------
# @author : Cyril
# @email  : wyy377244@163.com
# @date	  : 2020/07/02 
########################################
# @params : 
#      $1 : user
########################################

echo "Start Install NatFrp..."
set +e
ARCHITECTURE=""
uname -a | grep "aarch64"
if [ $? -eq 0 ];then
    wget --timeout 120 --tries 2 -O frpc_linux_arm64  https://qianqu.me/frp/frpc_linux_arm64
    ARCHITECTURE="aarch64"
    sudo chmod 777 frpc_linux_arm64
    nohup frpc_linux_arm64 -c /home/frpc.ini &
fi
uname -a | grep "armhf"
if [ $? -eq 0 ];then
    wget --timeout 120 --tries 2 -O frpc_linux_arm  https://qianqu.me/frp/frpc_linux_arm
    ARCHITECTURE="armhf"
    sudo chmod 777 frpc_linux_arm
    nohup frpc_linux_arm -c /home/frpc.ini &
fi
set -e


echo "NatFrp install complete and service is starting..."