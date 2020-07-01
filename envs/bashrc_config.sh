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
########################################
# @params : 
#      $1 : user
########################################

echo "Start Configure .bashrc environment..."

# path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# user="pi"
user=$1


cd ${path}


if [ -f "/home/${user}/.bashrc_bak" ];then
    ## 如果已存在备份文件则直接覆盖vimrc文件
    \cp -f ./src/bashrc /home/${user}/.bashrc
else
    ## 如果不存在备份文件则先备份
    mv /home/${user}/.vimrc /home/${user}/.vimrc_bak
    \cp -f ./src/vimrc /home/${user}/.vimrc 
fi

echo "bashrc configure completed!"