#!/bin/bash

## 脚本绝对路径, 不可被调用
## path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd) ## 真正的脚本绝对路径

## 可供调用的path
path=$(cd "$(dirname "$0")" && pwd)