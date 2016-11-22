#!/bin/bash 
 
EM="Error:This script must be run as root! please use *sudo -s* after *su -* to switch to root before the command. note NOT use *sudo* or *su* only"
 
function pre_install(){
	if [[ $UID -ne 0 ]]; then
	   echo $EM 1>&2
	   exit 1
	fi
	cd ~
	if [ $(pwd) != "/root" ];then
        echo $EM 1>&2
        exit 1
	fi
	cd -
}
