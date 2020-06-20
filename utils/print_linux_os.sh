#!/bin/bash
# -*- shell-script -*-
#####################################
# 打印当前Linux系统的版本名
#------------------------------------
# @author      : Cyril
# @version     : v1.0
# @script      : print_linux_os.sh
# @date        : 2020年 6月19日 星期五 23时17分34秒 CST
#####################################


type -p lsb_release > /dev/null 2>&1
if [ "$?" = 0 ]; then
    result=$(lsb_release -a 2> /dev/null | grep '^Description:' | sed -e 's/^Description:[ \t]*//g')
    echo $result
    exit 0
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $PRETTY_NAME
    exit 0
fi

if [ -f /etc/SuSe-release ]; then
    result=$(cat /etc/SuSe-release | head -n 1)
    echo $result
    exit 0
fi

if [ -f /etc/redhat-release ]; then
    result=$(cat /etc/redhat-release | head -n 1)
    echo $result
    exit 0
fi

uname -v | grep "^Darwin Kernel Version 19.5.0" &>/dev/null 
if [ $? -eq 0 ];then
    echo "Macos"
    exit 0
else
    echo $(uname -v)
    exit 1
fi

