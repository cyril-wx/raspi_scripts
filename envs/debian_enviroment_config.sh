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
ARCHITECTURE=$(uname -m) ## x86_64 | armv7l | aarch64


###########################################
###@repo源 更换为 Tsinghua源
# 1. debian10
# 2. 
###########################################
function update_repo()
{
    echo ">>>>update_repo"
    # 设置清华源
    
    case "${ID}${VERSION_ID}" in
    "debian10")
    # 设置备份文件
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
    apt install libc6:armhf ## 需要安装32位的"libc6:armhf"的基础库
    ;;
    
    *)
    echo "Unknown system version: ${ID}${VERSION_ID}, current unsupported."
    ;;
    echo ">>>>update_repo complete."
}


function set_static_ip()
{
    echo ">>>>set_static_ip for eth0"
    # 设置备份文件
    if [ ! -f "/etc/sshd_config.bak" ];then
        cp /etc/sshd_config /etc/sshd_config.bak
    fi
    sed -i '1i\"profile static_eth0"' /etc/dhcpcd.conf
    sed -i '1i\"interface eth0"' /etc/dhcpcd.conf
    sed -i '1i\"fallback static_eth0"' /etc/dhcpcd.conf
    sed -i '1i\"static ip_address=192.168.1.102/24"' /etc/dhcpcd.conf
    sed -i '1i\"static routers=192.168.1.1"' /etc/dhcpcd.conf
    sed -i '1i\"static domain_name_servers=192.168.1.1"' /etc/dhcpcd.conf
    echo ">>>>set_static_ip for eth0 complete."
}

function set_sshd()
{
    # 设置备份文件
    if [ ! -f "/etc/sshd_config.bak" ];then
        cp /etc/sshd_config /etc/sshd_config.bak
    fi
    # 允许RSA密钥登陆
    cat /etc/sshd_config | grep -E "^(RSAAuthentication)"
    if [ $? -eq 0 ];then
        sed -i 's/^(RSAAuthentication).*/"RSAAuthentication yes"/g'  /etc/sshd_config
    else
        echo "RSAAuthentication yes" >> /etc/sshd_config
    fi
    # 禁止SSH空密码用户登陆
    cat /etc/sshd_config | grep -E "^(PermitEmptyPasswords)"
    if [ $? -eq 0 ];then
        sed -i 's/^(PermitEmptyPasswords).*/"PermitEmptyPasswords no"/g'  /etc/sshd_config
    else
        echo "PermitEmptyPasswords no" >> /etc/sshd_config
    fi
    # 允许root用户远程登陆
    cat /etc/sshd_config | grep -E "^(PermitRootLogin)"
    if [ $? -eq 0 ];then
        sed -i 's/^(PermitRootLogin).*/"PermitRootLogin yes"/g'  /etc/sshd_config
    else
        echo "PermitRootLogin yes" >> /etc/sshd_config
    fi
}

### 初始化自定义环境变量
init_envs()
{
   update_repo
   set_static_ip
   set_sshd
}

init_envs
