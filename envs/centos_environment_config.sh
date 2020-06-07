#!/bin/bash
set +e
echo "centos_environment_config"


###########################################
###@Constant 系统环境变量
# 1. ID
# 2. VERSION_ID
###########################################
ID=$(cat /etc/os-release | grep "^ID=" | cut -d\" -f2)  ## centos
VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d\" -f2) ## 7/8


###########################################
###@repo源 更换为 Ali源
# 1. centos7
# 2. centos8
###########################################
case "${ID}${VERSION_ID}" in
"centos7")
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    fi
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    yum clean all
    yum makecache
;;
"centos8")
    if [ ! -f "/etc/yum.repos.d/CentOS-AppStream.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-AppStream.repo.bak
    fi
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    fi
    if [ ! -f "/etc/yum.repos.d/CentOS-Epel.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Epel.repo /etc/yum.repos.d/CentOS-Epel.repo.bak
    fi
    if [ ! -f "/etc/yum.repos.d/CentOS-Media.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo.bak
    fi
    
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
    yum clean all
    yum makecache
;;
*)
    echo "not support system version [${ID}${VERSION_ID}], repoes not be updated."
;;
esac
