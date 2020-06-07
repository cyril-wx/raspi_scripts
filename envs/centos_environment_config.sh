#!/bin/bash
set +e
echo "centos_environment_config"


###########################################
###@Constant 系统环境变量
# 1. ID
# 2. VERSION_ID
###########################################
ID=$(cat /etc/os-release | grep "^ID=" | cut -d\" -f2)  ## centos
VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d\" -f2) ## 7/8



###########################################
###@repo源 更换为 Ali源
# 1. centos7
# 2. centos8
###########################################
case "${ID}${VERSION_ID}" in
"centos7")
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    fi

;;
"centos8")
    cat <<EOF > /etc/yum.repos.d/CentOS-AppStream.repo
# file: /etc/yum.repos.d/CentOS-AppStream.repo
[AppStream]
name=CentOS-$releasever - AppStream
baseurl=http://mirrors.aliyun.com/centos/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF
    cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
# file: /etc/yum.repos.d/CentOS-Base.repo
[BaseOS]
name=CentOS-$releasever - Base
baseurl=http://mirrors.aliyun.com/centos/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF
    cat <<EOF > /etc/yum.repos.d/CentOS-Epel.repo
# file: /etc/yum.repos.d/CentOS-Epel.repo
[epel]
name=CentOS-$releasever - Epel
baseurl=http://mirrors.aliyun.com/epel/8/Everything/$basearch
enabled=1
gpgcheck=0
EOF
    cat <<EOF > /etc/yum.repos.d/CentOS-Media.repo
# file: /etc/yum.repos.d/CentOS-Media.repo
# 注：CentOS-Media 配置需要将光盘挂载至/media/CentOS路径，否则在使用时会报错。
[c8-media-BaseOS]
name=CentOS-BaseOS-$releasever - Media
baseurl=file:///media/CentOS/BaseOS/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
[c8-media-AppStream]
name=CentOS-AppStream-$releasever - Media
baseurl=file:///media/CentOS/AppStream/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF
;;
*)
    echo "not support system version [${ID}${VERSION_ID}], repoes not be updated."
;;
esac