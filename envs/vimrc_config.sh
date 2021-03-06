#!/bin/bash
set -x
set -e
set -o pipefail

## 引入公共变量
. ../utils/variables.sh
# >>>>>引入公共变量
#   path   : 当前运行脚本绝对路径
# <<<<<

########################################
# 配置个性化vim环境
#--------------------------------------
# @author : Cyril
# @email  : wyy377244@163.com
# @date	  : 2020/07/02 
# @tips	  : 不支持配置root用户
########################################
# @params : 
#      $1 : user
########################################

echo "Start Configure .vimrc/.virc environment..."

# path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)  ## 真正的脚本绝对路径
# user="pi"
user=$1
if [[ x"${user}" == x"" ]] || [ ! -d "/home/${user}" ];then
	echo """Usage: ./$0 <user>. 
The user must be exists in home dir."""
	exit 1
fi

cd ${path}

if [ -f "/home/${user}/.vimrc_bak" ];then
    ## 如果已存在备份文件则直接覆盖vimrc文件
    \cp -f ./src/vimrc /home/${user}/.vimrc
else
    ## 如果不存在备份文件则先备份
    mv /home/${user}/.vimrc /home/${user}/.vimrc_bak
    \cp -f ./src/vimrc /home/${user}/.vimrc 
fi

if [ -f "/home/${user}/.virc_bak" ];then
    ## 如果已存在备份文件则直接覆盖virc文件
    \cp -f ./src/vimrc /home/${user}/.virc
else
    if [ -f "/home/${user}/.virc" ];then
        ## 如果不存在备份文件则先备份
        mv /home/${user}/.virc /home/${user}/.virc_bak
    fi
    \cp -f ./src/vimrc /home/${user}/.virc 
fi

echo "vimrc/virc configure completed!"
