#!/bin/bash
#set +e

##########################################
### 获取系统信息及初始化使用
# 支持系统版本：
# 1. raspbian debian10
#----------------------------------------
# @author : Cyril
# @email  : wyy377244@163.com
# @create : 2020-07-06 23:40:25
##########################################

echo ">>> debian_environment_config <<<"
###########################################
###@Constant 系统环境变量
# 1. ID
# 2. VERSION_ID
###########################################
ID=$(cat /etc/os-release | grep "^ID=" | cut -d\" -f2)  ## centos| raspbian
VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d\" -f2) ## 7| 8| 10
ARCHITECTURE=$(uname -m) ## x86_64 | armv7l


###########################################
###@repo源 更换为 Tsinghua源
# 1. debian10
# 2. 
###########################################
function update_repo()
{
case "${ID}${VERSION_ID}" in
"debian10")
    if [ ! -f "/etc/apt/sources.list.bak" ];then
        mv /etc/apt/sources.list /etc/apt/sources.list.bak
        cat <<EOF > /etc/apt/sources.list
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main non-free contrib                                                                                                                                 
deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main non-free contrib
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main non-free contrib
EOF
    else
        
        set -i 's/^/#&/g' /etc/apt/sources.list
        cat <<EOF >> /etc/apt/sources.list
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main non-free contrib                                                                                                                                 
deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main non-free contrib
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main non-free contrib
EOF
    fi
        
    ## 开启32位软件armhf支持
    dpkg --add-architecture armhf
    apt update
    apt install libc6:armhf ## 需要先安装32位的"libc6:armhf"的基础库
;;
*)
    echo "Unknown system version: ${ID}${VERSION_ID}, current unsupported."
;;
}

### 初始化自定义环境变量
init_envs()
{
   update_repo
}

init_envs
