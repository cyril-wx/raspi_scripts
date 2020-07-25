#!/bin/bash
set -ex
set -o pipefail

# >>>>>引入公共变量
#   path   : 当前运行脚本绝对路径
#   FRPC_DOMAIN : frpc 服务器域名
#   FRPC_HOME   : frpc Home路径
#   FRPC_ARM64
#   FRPC_ARM32
#   FRPC_SPATH
#   ARCHITECTURE: 获取架构名
# <<<<<
. ../utils/variables.sh

########################################
# 启动natfrp(arm64)
#--------------------------------------
# @author : Cyril
# @email  : wyy377244@163.com
# @date	  : 2020/07/02 
########################################
# @params : None
########################################

echo "Start Install NatFrp..."

##指定安装路径
INSTALL_PATH="/opt/natfrp"
##指定配置文件路径
CONF=${INSTALL_PATH}/frpc.ini
FRPC_LOG=$(mktemp)

if [ ! -d  "/opt/natfrp" ];then
    sudo mkdir -p ${INSTALL_PATH}
fi
sudo chmod -R 777 ${INSTALL_PATH}

## 下载frpc配置文件
set +e
cd ${INSTALL_PATH}
python3 natfrp_helper.py downloadConfFromFrp ${CONF} ### 下载frpc.ini, 默认路径/tmp/frpc.ini
set -e


## 下载frpc客户端
case $(ARCHITECTURE) in
    "armhf")
    wget --timeout 120 --tries 2 -O ${FRPC_ARM32}  ${FRPC_SPATH}/${FRPC_ARM32}
    ;;
    "aarch64")
    wget --timeout 120 --tries 2 -O ${FRPC_ARM64}  ${FRPC_SPATH}/${FRPC_ARM64}
    ;;
    *)
    return 255    ##异常退出
    ;;
esac


echo "NatFrp install complete and service is starting..."