#!/bin/bash
DAY=`date +%d`
if [ "$DAY" = 01 ] ; then
  echo 'today is the first day of this month'
else
  echo 'today is not the first day of this month'
fi
#disable the traffic control
sudo iptables -D OUTPUT -s 172.31.18.215
echo 'disabled the traffic control.'