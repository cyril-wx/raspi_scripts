#!/bin/bash
#set +e

##########################################
### 获取系统信息及初始化使用
# 支持系统版本：
# 1. centos7
# 2. centos8
# 3. raspbian
##########################################

echo "centos_environment_config"
###########################################
###@Constant 系统环境变量
# 1. ID
# 2. VERSION_ID
###########################################
ID=$(cat /etc/os-release | grep "^ID=" | cut -d\" -f2)  ## centos| raspbian
VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d\" -f2) ## 7| 8| 10
ARCHITECTURE=$(uname -m) ## x86_64 | armv7l


###########################################
###@repo源 更换为 Ali源
# 1. centos7
# 2. centos8
###########################################
function update_repo()
{
case "${ID}${VERSION_ID}" in
"centos7")
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    fi

    if [ x"${ARCHITECTURE}"~=$"armv7l" ];then
        ## 适用于树莓派
        curl -o /etc/yum.repos.d/CentOS-Base.repo http://h5ai.chinared.xyz/repository/centos/arm/CentOS-Base.repo
    else
        curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    fi

    yum clean all
    yum makecache
;;
"centos8")
    if [ ! -f "/etc/yum.repos.d/CentOS-AppStream.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-AppStream.repo.bak
    fi
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    fi
    if [ ! -f "/etc/yum.repos.d/CentOS-Epel.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Epel.repo /etc/yum.repos.d/CentOS-Epel.repo.bak
    fi
    if [ ! -f "/etc/yum.repos.d/CentOS-Media.repo.bak" ];then
        mv /etc/yum.repos.d/CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo.bak
    fi
   
    if [ x"${ARCHITECTURE}"~=$"x86_64" ];then
        curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
    fi
    yum clean all
    yum makecache
;;
"macos")
    COREs=$(sysctl machdep.cpu | grep -E "^machdep.cpu.thread_count: [0-9]+$" | cut -d " " -f2)
    ## 安装brew
    git clone git://mirrors.ustc.edu.cn/homebrew-core.git//usr/local/Homebrew/Library/Taps/homebrew/homebrew-core --depth=1
    ## 安装brew cask
    rm -rf /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask
    git clone git://mirrors.ustc.edu.cn/homebrew-cask.git//usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask --depth=1
    ## 替换成国内源
    cd "$(brew --repo)"
    git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask"
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
    ## 安装Homebrew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install >> brew_install
    sed -i 's/BREW_REPO.*freeze/BREW_REPO\=\"git\:\/\/mirrors\.ustc\.edu\.cn\/brew\.git\"\.freeze/g' brew_install
    sed -i 's/CORE_TAP_REPO.*freeze/CORE_TAP_REPO\=\"git\:\/\/mirrors\.ustc\.edu\.cn\/homebrew\-core\.git\"\.freeze/g' brew_install
    ## 中科院的镜像
    git clone git://mirrors.ustc.edu.cn/homebrew-core.git//usr/local/Homebrew/Library/Taps/homebrew/homebrew-core --depth=1
    /usr/bin/ruby brew_install
    ## 把Homebrew-core的镜像地址也设置为中科院的国内镜像
    cd "$(brew --repo)"
    git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

    brew update

    ## 替换核心软件仓库：
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

    ## 替换cask软件仓库：
    cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git

    ## 替换Bottle源：
    #bash用户（shell用户）：
    echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
    source ~/.bash_profile
    #zsh用户：
    echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
    source ~/.zshrc


    brew update && brew upgrade
;;
*)
    echo "not support system version [${ID}${VERSION_ID}], repoes not be updated."
;;
esac
}

### 初始化自定义环境变量
init_envs()
{
   update_repo
}

init_envs
