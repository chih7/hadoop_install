#!/bin/bash

source /etc/profile.d/hadoop.sh

. lib.sh

pre_install

echo -e "\n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "\n"

