#!/bin/bash
set -ex

##source ./../envs/centos_environment_config.sh

set +e
# yum -y install yum-plugin-versionlock centos7
###Carefully, do not add "yum versionlock clean" if you don't known what you do.####
# yum versionlock clean # centos7

which -v
if [ $? -ne 0 ];then
	yum -y install which
fi
which sudo
if [ $? -ne 0 ];then
	yum -y install sudo
fi
which wget
if [ $? -ne 0 ];then
	sudo yum -y install wget
fi
which expect
if [ $? -ne 0 ];then
	sudo yum -y install expect
fi
which sshd
if [ $? -ne 0 ];then
	sudo yum -y install openssh-server openssh-clients
fi
which git
if [ $? -ne 0 ];then
	sudo yum -y git
fi
which ifconfig
if [ $? -ne 0 ];then
	sudo yum -y net-tools
fi
set -e
