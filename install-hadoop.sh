#!/bin/bash

#auto_install hadoop
#design for ubuntu and debian but only tested in ubuntu server 16.04
#Maintainer: Jiaxin Qi i@chih.me

pkgver=2.7.3
mirror=http://mirrors.aliyun.com
depends=(openssh-server openjdk-8-jdk wget)
MASTER_HOST="hadoop-master"
#fixme while [ $i -lt $N ];do
SLAVE_HOST1="hadoop-slave1"
SLAVE_HOST2="hadoop-slave2"
MASTER_IP="192.168.56.101"
SLAVE_IP1="192.168.56.102"
SLAVE_IP2="192.168.56.103"

. ./hadoop_config/lib.sh

function install_depends(){
	apt-get update
	for i in ${depends[*]}; do
		if ! dpkg -l "$i">/dev/null ; then
	    	apt-get -y install $i
	   	fi
	done	
}

function install_hadoop(){
    if [ -e hadoop-${pkgver}.tar.gz ];then
        rm hadoop-${pkgver}.tar.gz
	fi
#	while true
#	do
#        wget $(mirror)/apache/hadoop/common/hadoop-${pkgver}/hadoop-${pkgver}.tar.gz
#        wget $(mirror)/apache/hadoop/common/hadoop-${pkgver}/hadoop-${pkgver}.tar.gz.mds
#        md5_1 = `cat hadoop-2.6.0.tar.gz.mds | grep 'MD5'`
#        md5_2 = `md5sum hadoop-${pkgver}.tar.gz | tr "a-z" "A-Z"`
#        if [ $md5_1 == $md5_2 ];then
#            break
#        else
#            echo "checksum not pass"
#        fi
#    done
    wget ${mirror}/apache/hadoop/common/hadoop-${pkgver}/hadoop-${pkgver}.tar.gz && \
    tar -xzvf hadoop-${pkgver}.tar.gz && \
    mv hadoop-${pkgver} /usr/local/hadoop
}

function config(){
#ENV
    echo "
# set environment variable
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
export HADOOP_HOME=/usr/local/hadoop 
export PATH=\$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
"   >> /etc/profile.d/hadoop.sh
    source /etc/profile.d/hadoop.sh
    
    echo "$MASTER_IP    $MASTER_HOST" >> /etc/hosts
    echo "$SLAVE_IP1    $SLAVE_HOST1" >> /etc/hosts
    echo "$SLAVE_IP2    $SLAVE_HOST2" >> /etc/hosts
    
    mkdir -p /data/hdfs/namenode && \
    mkdir -p /data/hdfs/datanode && \
    mkdir -p $HADOOP_HOME/logs
    
    # ssh without key
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    
    cp -r ./hadoop_config/* /tmp/
    
    mv /tmp/ssh_config /root/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh /root/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh /root/run-wordcount.sh && \
    mv /tmp/lib.sh /root/lib.sh
    
    chmod +x /root/start-hadoop.sh && \
    chmod +x /root/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh
    
    # format namenode
    /usr/local/hadoop/bin/hdfs namenode -format
}

pre_install
install_depends
install_hadoop
config

echo "Done! please reboot" 1>&2
