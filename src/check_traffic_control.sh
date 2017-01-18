#!/bin/bash
value_string=`sudo iptables -n -v -L -t filter |grep -i "172.31.18.215"|awk -F' ' '{print $2}'`
echo $value_string
