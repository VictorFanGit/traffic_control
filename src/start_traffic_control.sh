#!/bin/bash
sudo iptables -D OUTPUT -s 172.31.18.215
echo 'disable the traffic control'
sudo iptables -I OUTPUT -s 172.31.18.215
echo 'enable the traffic control'
#sudo iptables -I OUTPUT -s 172.31.18.215 -p tcp --sport $PORT2
#sudo ssserver -c /etc/shadowsocks.json -d start > logshadow.log 2>&1 &

echo 'loop to check the traffic, if overflow stop the service'
M_MAX=12000
G_MAX=12
echo "limited traffic is $G_MAX G"
SLEEP_TIME=60 #loop delay time
echo "loop delay time is : $SLEEP_TIME seconds"
while true
do
  value_string=`sudo iptables -n -v -L -t filter |grep -i "172.31.18.215"|awk -F' ' '{print $2}' | head -1`
  value1=${value_string%M*}
  #value=`echo $value_string1 |tr -d 'M'`
  if [ $value1 != $value_string ] ;then
    #echo $value1
    if [ $value1 -gt $M_MAX ]; then
      echo "traffic overflow!!!"
      echo "stop the ss service!"
      PID_NUM=`pgrep ssserver`
      sudo kill -9 $PID_NUM
      #close the traffic
      sudo iptables -D OUTPUT -s 172.31.18.215
      break
    fi
  fi
  value2=${value_string%G*}
  #echo $value_string1 | grep 'G'
  if [ $value2 != $value_string ] ;then
    #echo $value2
    if [ $value2 -gt $G_MAX ]; then
      echo "traffic overflow!!!"
      echo "stop the ss service!"
      PID_NUM=`pgrep ssserver`
      sudo kill -9 $PID_NUM
      #close the traffic
      sudo iptables -D OUTPUT -s 172.31.18.215
      break
    fi
  fi
  sleep $SLEEP_TIME

  DAY=`date +%d`
  if [ "$DAY" = 01 -a $first_day_flag = 0 ] ;then
    sudo iptables -D OUTPUT -s 172.31.18.215
    sleep $SLEEP_TIME
    sudo iptables -I OUTPUT -s 172.31.18.215
    echo "reset the traffic."
    first_day_flag=1
  elif [ "$DAY" != 01 -a $first_day_flag = 1 ] ; then
    first_day_flag=0
  fi

done
