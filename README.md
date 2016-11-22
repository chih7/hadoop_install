# Install Hadoop Cluster with shell script

Hadoop install script for debian and Ubuntu. but only tested in Ubuntu Server 16.04.

The script will let you setup a 3 node Hadoop cluster in no more than 10 minutes.

## Installation in a node

```sh
get clone https://github.com/chih7/hadoop_install.git
```

```sh
sudo -s
```

```sh
su -
```

```sh
./hadoop/install_hadoop.sh
```

```
reboot
```

Done

## Run as a cluster

clone the machine or install hadoop in other machine with the script.

note the ip address must same with the script.

in hadoop master machine

```sh
sudo -s
```

```sh
su -s
```

```sh
./start-hadoop.sh
```

Done