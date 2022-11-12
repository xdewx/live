#!/bin/bash

# 借助echo -e实现彩色输出，如果文字参数中含有选项符号，则--应作为log的·选项终止符
function log(){
    declare -A map=(["s"]="40;32" ["d"]="40;37" ["i"]="40;33" ["w"]="40;34" ["e"]="40;31" ["f"]="41;37")
    dt=`date '+%y-%m-%d %H:%M:%S'`
    ARGS=`getopt -n $0 -o sdiwefn -l success,debug,info,warn,error,fatal -- "$@"`
    eval set -- $ARGS
    if [[ $? != 0 ]];then
        echo "parse error" && exit 1
    fi
        newline=1
    k='d'
    while true; do
        case $1 in
			-n)
			newline=0;shift;;
            -s|--success)
                k=s;shift;;
            -d|--debug)
                k=d;shift;;
            -i|--info)
                k=i;shift;;
            -w|--warn)
                k=w;shift;;
            -e|--error)
                k=e;shift;;
            -f|--fatal)
                k=f;shift;;
            --)
                shift;break;;
            # *)
            #     k=${2:1:1};shift;;
        esac
    done
    color=${map[$k]}
    if [[ ! "$color" ]];then
        color=${map['d']}
    fi
    x="\033[${color}m[${k^^} $dt] - $@\033[0m"
    # echo $k,$x
        if [[ $newline -eq 1 ]];then
                echo -e "$x"
        else
                echo -n -e "$x"
        fi
}

# 输出后并调用eval执行
function echorun(){
    log -i -- "[ $@ ]" && eval "$@"
}