#!/bin/bash
# -- autossh 内网端 A 机器 --

while true;do

cdate=`date`

RET=`ps ax | grep "autossh" | grep -v "grep"`

if [ -z "$RET" ]; then


        echo "[$cdate] Restart ssh server..." >> autossh_test.log 

        autossh -M 5678 -f -N -R 25022:localhost:22 root@chinared.xyz -p 15222 >>autossh_test.log

fi

sleep 100

done
