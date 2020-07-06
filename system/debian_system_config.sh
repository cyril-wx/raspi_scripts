#!/bin/bash
set -ex

# >>>>>引入公共变量
#   CHECK_SYS: -r -a -m
#   USER:
# <<<<<
source ../utils/variables.sh

###检查系统版本
CHECK_SYS -r debian
CHECK_SYS -a 9
CHECK_SYS -a 10


function apps_install()
{
    ###执行必要软件安装
    sudo apt autoremove
    sudo apt -y install wget expect openssh-server net-tools git
}

function env_config()
{
    ###环境配置
    source ../envs/debian_enviroment_config.sh
    init_envs
    chmod u+x ../envs/bashrc_config.sh
    chmod u+x ../envs/vimrc_config.sh
    bash ../envs/bashrc_config.sh
    bash ../envs/vimrc_config.sh
}

function auto_startup()
{
    ###开机自启项配置
    cat <<EOF > /etc/rc.local
supervisor_log="/tmp/run_my_supervisors.log"
nohup /home/${USER}/run_my_supervisors.sh \${supervisor_log} &> \${supervisor_log} &
EOF
}

function hosts_config()
{
    ###Hosts配置
    chmod u+x ../envs/hosts_config.sh
    bash ../envs/hosts_config.sh
}


function main()
{
    echo ">>>>Start debian_enviroment_config"
    apps_install
    auto_startup
    env_config
    hosts_config
    echo ">>>>debian_enviroment_config completed!"
}

main