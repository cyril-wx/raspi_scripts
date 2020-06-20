#!/bin/bash

## 创建带有个人署名的模版文件
## 不支持MacOS系统运行

set -e
set -o pipefail
name=$0


function Usage()
{
      cat <<EOF
Usage: ${name} [-t file_type] [-n file_name] [-a author_name] 
          [-p title] [-c description_content ] [ -e author_email ] 

Add -v for verbose mode, -h to display this message.
EOF
}
##@参数解析
while getopts "t:n:a:p:c:e:vh" opt; do
  case $opt in
    t)
      TYPE=$OPTARG
      ;;
    n)
      FNAME=$OPTARG
      ;;
    a)
      ANAME=$OPTARG
      ;;
    p)
      TITLE=$OPTARG
      ;;
    c)
      DESCRI=$OPTARG
      ;;
    e)
      EMAIL=$OPTARG
      ;;
#    E)
#      export SERVICE_ENDPOINT=$OPTARG
#      ;;
    v)
      set -x
      ;;
    h)
      Usage
      exit 0
      ;;
    \?)
      echo "Unknown option -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument" >&2
      exit 1
      ;;
  esac
done

if [ $# -lt 2 ]; then
    Usage
    exit 255
fi

TEMPLETE_FILE=$(mktemp)
cat <<EOF > ${TEMPLETE_FILE}
#!<-COMPILER->
#
###############################################
## <-TITLE->      | ver: 1.0
## <-DESCRI->
#---------------------------------------------
## @author: <-ANAME->
## @email : <-EMAIL->
## @date  : $(date)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Functions:
#   - 1
#   - 2
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#

EOF
if [[ x"${FNAME}" != x"" ]]; then 
    new_file="${TEMPLETE_FILE%/*}/${FNAME}"
    cp ${TEMPLETE_FILE} ${new_file}
    TEMPLETE_FILE=${new_file}
fi

if [[ x"${TYPE}" != x"" ]]; then 
    mv ${TEMPLETE_FILE} ${TEMPLETE_FILE}.${TYPE}
    TEMPLETE_FILE="${TEMPLETE_FILE}.${TYPE}"
fi

REPLACE_KEYS=(ANAME TITLE TYPE FNAME DESCRI EMAIL)
for i in ${REPLACE_KEYS[@]}
do
    if [[ x"$i" != x"" ]];then
        new_str=$(eval echo '$'$i)
        echo "replace $i:$new_str"
        bash -c "sed -i 's:<-${i}->:${new_str}:' ${TEMPLETE_FILE} "
    fi
done

echo "Create: ${TEMPLETE_FILE}"


