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

###@检查系统版本
function CHECK_SYS()
{
    set -e
    local res=0
    . /etc/os-release   ## debian/centos/ubuntu 都有它
    let res+=$?
    while getopts ":r:a:m" opt
    do
    case $opt in
        r) ## check Kernel version(centos/debian/)
        OPTARG=$(echo $OPTARG | tr 'A-Z' 'a-z')
        ID=$(echo ${ID} | tr 'A-Z' 'a-z')
        if [[ x"$OPTARG" == x"${ID}" ]];then
            let res+=$?
        else
            exit 1
        fi
        ;;
        
        a)  ## check Kernel version no.
        OPTARG=$(echo $OPTARG | tr 'A-Z' 'a-z')
        VERSION_ID=$(echo ${ID} | tr 'A-Z' 'a-z')
        if [[ x"$OPTARG" == x"${VERSION_ID}" ]];then
            let res+=$?
        else
            exit 1
        fi
        ;;
        m) ## check ARCHITECTURE(armhf/aarch64)
        OPTARG=$(echo $OPTARG | tr 'A-Z' 'a-z')
        ARCH=$(ARCHITECTURE)
        if [[ x"$OPTARG" == x"${ARCH}" ]];then
            let res+=$?
        else
            exit 1
        fi
        ;;
        ?)
        echo "Unknow input"
        exit 1
        ;;
    esac
    done
    echo "ok"
}



set -e
