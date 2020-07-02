#!/bin/bash
set -x  ###调试模式
set +e  ###脚本非零立即退出(-e)/不退出(+e)
set -o pipefail   ###返回管道命令最后一个非零值
##############################
# 自定义守护进程
#---------------------------- 
# @Author: Cyril
# @Create: 2020-06-05 23:17:17  
# @Modified: 2020-07-02
# @Input: None
# @Output: None
##############################

### 参数解析
current_proc_id=$$
script_name=$0
C_LOG=$(mktemp) ### code tornado 服务器运行log

# >>>>>引入公共变量
#   path   : 当前运行脚本绝对路径
#   FRPC_DOMAIN : frpc 服务器域名
#   FRPC_HOME   : frpc Home路径
#   FRPC_ARM64
#   FRPC_ARM32
#   FRPC_SPATH
#   ARCHITECTURE: 获取架构名
# <<<<<
. ../utils/variables.sh

###@杀掉其它同名进程by名称############
# desc: 
#   杀掉本脚本的其它同名进程根据给定的名称（名称支持模糊匹配), 不包含本脚本
# input: 
#   $1: 进程名/运行脚本名
# output: 
#   0: success/1-?: fail
# modified: 
#   2020-06-05 23:44:34 By Cyril 
#-----------------------------
function kill_other_process()
{
    local res=0
    for i in $(ps -ef | grep ${proc_name} | grep -vE "[0-9]+:[0-9]{2}.[0-9]{2}( grep )" | awk -F ' ' '{print $2}')
    do
        if [[ x"${current_proc_id}" != x"${i}" ]] && [[ x"${i}" != x"" ]];then
            sudo kill -9 ${i} 
            let res+= 1
        fi  
    done
    retrun ${res}
}

###@杀掉进程by名称############
# desc: 
#   杀掉所有指定进程根据给定的名称（名称支持模糊匹配)
# input: 
#   $1: 指定进程名/运行脚本名
# output: 
#   0: success/1: fail
# modified: 
#   2020-06-05 23:44:34 By Cyril 
#-----------------------------
function kill_process()
{
    set +e
    for i in $(ps -ef | grep "$1" | grep -vE "[0-9]+:[0-9]{2}.[0-9]{2}( grep )" | awk -F ' ' '{print $2}') 
    do   
        sudo kill -9 ${i}
    done
    set -e
    return $?
}

###@check_network_status############
# desc: 
#   检查网络连接状态(h5ai.chinared.xyz)
# input: 
#   None
# output: 
#   http_code
# modified: 
#   2020-06-06 00:30:55 By Cyril 
#-----------------------------
function check_network_status()
{
    http_code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} h5ai.chinared.xyz/.well-known/ping.txt)
    echo ${http_code}
}

# 启动frpc守护进程
function start_frpc_daemon()
{
    local frp_log=$(mktemp -p ./)
    local frp_dir=${FRPC_HOME}
    local frp_config=".frpc.ini"
    case $(ARCHITECTURE) in
        "armhf")
        local frp_name=${FRPC_ARM32}
        ;;
        "aarch64")
        local frp_name=${FRPC_ARM64}
        ;;
        *)
        return 255    ##异常退出
        ;;
    esac
    
    if [ ! -f "${frp_dir}/${frp_name}" ] || [ ! -f ${frp_dir}/frpc.ini ]
    
    while((1))
    do
        echo $(check_network_status) | grep -E "^[0-9]+$" &>/dev/null
        if [ $? -eq 0 ] && [ $(check_network_status) -ne 200 ];then
            echo "[$(date)] Restart ${proc_name}"
            # 重启frp之前杀死所有同名进程
            kill_process ${frp_name}
            ${frp_dir}/${frp_name} -c ${frp_dir}/frpc.ini > ${frp_log} & 
            sleep 10
            grep -E "(隧道启动成功)[\ ]+" ${frp_log} 
            if [ $? -eq 0 ];then
                echo "[$(date)] 隧道启动成功，循环检查休眠60s"
                sleep 60 # 隧道成功启动，循环检查休眠60s
            else
                echo "[$(date)] 隧道启动失败，重试..."
                
				# 检查ip是否变动，若有，则更新frpc.ini中ip
                local frp_ip=$(ping ${FRPC_DOMAIN} -c1 -t 1 | head -n1 | grep -oE "\([0-9|.]+\)" | tr -d "[\(|\)]")
                record_ip=$(cat ${frp_config} | grep "server_addr" | cut -d "=" -f2 | awk '$1=$1')
                if [[ ${frp_ip} != ${record_ip} ]];then
                    sed  "s/server_addr = \([0-9.]*\)/server_addr = ${frp_ip}/g" ${frp_config}
                fi
                
                continue
            fi
        else
            echo "[$(date)] 隧道网络正常，循环检查休眠60s"
            sleep 60 # 网络正常，休眠60s   
        fi
    done
    echo "[$(date)] start_frpc_daemon::守护进程异常中断"
    return 1
}



###@运行主函数
function main()
{
    echo "START_TIME: $(date)" 
    # kill其它同名进程 
    kill_other_process ${proc_name}

    # 重启code run tornado 服务
    kill_process my_tornado_server
    cd /www/wwwroot/code.chinared.xyz/my_tornado_server/src/server
    sudo python3 /www/wwwroot/code.chinared.xyz/my_tornado_server/src/server/app.py >> ${C_LOG} &

    # 重启redis
    sudo systemctl restart redis

    # 启动frpc守护进程
    start_frpc_daemon
    echo "END_TIME: $(date)"
}

main ### 将脚本注入rc.local实现开机自启
exit 1
