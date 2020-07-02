#!/bin/bash
set +e
## 脚本绝对路径, 不可被调用
## path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd) ## 真正的脚本绝对路径

path=$(cd "$(dirname "$0")" && pwd) ## 可供调用的path

FRPC_DOMAIN="jp-tyo-dvm.sakurafrp.com"  ## frpc 服务器域名
FRPC_SPATH="https://qianqu.me/frp/"
FRPC_ARM64="frpc_linux_arm64"
FRPC_ARM32="frpc_linux_arm"
FRPC_HOME="/opt/natfrp" ## frpc Home路径


USER="root" ## 当前用户


###@获取架构名
function ARCHITECTURE()
{
    arch=$(uname -a | grep -oE "(armhf|aarch64)")
    if [ $? -eq 0 ];then
        echo ${arch}
    else
        echo ""
    fi
}


set -e
