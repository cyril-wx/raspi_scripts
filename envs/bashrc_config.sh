#!/bin/bash
set -ex
set -o pipefail


## 引入公共变量
. ../utils/variables.sh
# >>>>>引入公共变量
#   path   : 当前运行脚本绝对路径
# <<<<<

########################################
# 配置个性化bashrc环境
#--------------------------------------
# @author : Cyril
# @email  : wyy377244@163.com
# @date	  : 2020/07/02 
# @tips	  : 不支持配置root用户
########################################
# @params : 
#      $1 : user
########################################

echo "Start Configure .bashrc environment..."

# path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# user="pi"
user=$1
if [[ x"$user" == x"" ]] || [ ! -d "/home/${user}" ];then
	echo """Usage: ./$0 <user>. 
	The user must be exists in home dir."""
        exit 1
fi

cd ${path}
    
if [ -f "/home/${user}/.bashrc_bak" ];then
    ## 如果已存在备份文件则直接覆盖vimrc文件
    \cp -f ./src/bashrc /home/${user}/.bashrc
else
    if [ -f "/home/${user}/.bashrc" ];then
        ## 如果不存在备份文件则先备份
        mv /home/${user}/.bashrc /home/${user}/.bashrc_bak
    fi
    \cp -f ./src/bashrc /home/${user}/.bashrc
fi

echo "bashrc configure completed!"
