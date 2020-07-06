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
# 配置Hosts
#--------------------------------------
# @author : Cyril
# @email  : wyy377244@163.com
# @date	  : 2020/07/06
########################################
# @params : 
#      
########################################

echo "Start ${FUNCNAME} configure..."

if [ ! -f "/etc/hosts.bak" ];then
    ## 创建备份文件
    sudo cp /etc/hosts /etc/hosts.bak
fi

cat <<EOF >> /etc/hosts

### GitHub Start 
140.82.113.3      github.com
140.82.114.20     gist.github.com
151.101.184.133    assets-cdn.github.com
151.101.184.133    raw.githubusercontent.com
151.101.184.133    gist.githubusercontent.com
151.101.184.133    cloud.githubusercontent.com
151.101.184.133    camo.githubusercontent.com
151.101.184.133    avatars0.githubusercontent.com
199.232.68.133     avatars0.githubusercontent.com
199.232.28.133     avatars1.githubusercontent.com
151.101.184.133    avatars1.githubusercontent.com
151.101.184.133    avatars2.githubusercontent.com
199.232.28.133     avatars2.githubusercontent.com
151.101.184.133    avatars3.githubusercontent.com
199.232.68.133     avatars3.githubusercontent.com
151.101.184.133    avatars4.githubusercontent.com
199.232.68.133     avatars4.githubusercontent.com
151.101.184.133    avatars5.githubusercontent.com
199.232.68.133     avatars5.githubusercontent.com
151.101.184.133    avatars6.githubusercontent.com
199.232.68.133     avatars6.githubusercontent.com
151.101.184.133    avatars7.githubusercontent.com
199.232.68.133     avatars7.githubusercontent.com
151.101.184.133    avatars8.githubusercontent.com
199.232.68.133     avatars8.githubusercontent.com
### GitHub End
EOF

echo "Complete ${FUNCNAME} configure"
