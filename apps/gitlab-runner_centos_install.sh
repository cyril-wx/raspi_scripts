#!/bin/bash
set -ex

###System Params###
ID=$(cat /etc/os-release | grep "^ID=" | cut -d\" -f2)
VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d\" -f2)

###Carefully, do not add clean if you have known what you do.####
set +e
yum versionlock clean

which -v
if [ $? -ne 0 ];then
        yum -y install which
fi
which wget
if [ $? -ne 0 ];then
	yum -y install wget
fi
which sudo
if [ $? -ne 0 ];then
	yum -y install sudo
fi
which expect
if [ $? -ne 0 ];then
	yum -y install expect
fi
set -e

which gitlab-runner
if [ $? -ne 0 ];then
	curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
	yum install -y gitlab-runner
fi

EXP_REGISTER_RUNNER=$(mktemp)
cat <<EOF > ${EXP_REGISTER_RUNNER}
set timeout 30
spawn sudo gitlab-runner register
expect "coordinator URL" { send "http://gitlab.chinared.xyz\r" }
expect "gitlab-ci token" { send "bs_nM8HpXSxUAgsBUPNo\r" }
expect "gitlab-ci description" { send "slave-${ID}${VERSION_ID}-runner\r" }
expect "gitlab-ci tags" { send "slave-${ID}${VERSION_ID}-runner\r" }
expect "Whether to run untagged builds" { send "true\r" }
expect "Whether to lock Runner to current project" { send "false\r" }
expect "Please enter the executor" { send "shell\r" }
expect eof
EOF

EXP_RES=$(mktemp)
expect -f ${EXP_REGISTER_RUNNER} > ${EXP_RES}
rm -rf ${EXP_REGISTER_RUNNER}

grep "successful" ${EXP_RES}
#rm -rf ${EXP_RES}

echo "all jobs completed!"
