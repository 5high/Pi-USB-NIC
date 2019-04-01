#!/bin/bash
sudo su
bash <(curl -L -s https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/install-without-dns.sh)
bash <(curl -L -s https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/install-without-dns.sh)
bash <(curl -L -s https://install.direct/go.sh)

#增加开机启动
lines=(
    'sleep 20'
    'iptables -t nat -A POSTROUTING -j MASQUERADE'
    'GW=`netstat -rn|grep '0.0.0.0'|awk '{print $2}'|head -1`'
    'HOST_IP=$(ifconfig |grep broadcast |awk '{print $2}')'
    'sudo ip rule add fwmark 0x01/0x01 table 100'
    'sudo ip route add local 0.0.0.0/0 dev lo table 100'
    'sudo iptables -t mangle -N V2RAY'
    'sudo iptables -t mangle -N V2RAY'
    'sudo iptables -t mangle -I V2RAY -d 192.168.0.0/16 -j RETURN'
    'sudo iptables -t mangle -I V2RAY -d $GW/32 -j RETURN'
    'for line in $HOST_IP'
    'do'
    'sudo iptables -t mangle -I V2RAY -d $line/32 -j RETURN'
    'done'
    'sudo iptables -t mangle -I V2RAY -d 127.0.0.1/32 -j RETURN'
    'sudo iptables -t mangle -A V2RAY -p udp -j TPROXY --on-port 12345 --tproxy-mark 0x01/0x01'
    'sudo iptables -t mangle -A V2RAY -p tcp -j TPROXY --on-port 12345 --tproxy-mark 0x01/0x01'
    'sudo iptables -t mangle -A PREROUTING -j V2RAY'
    )
    
    for line in "${lines[@]}"; do
        if grep "$line" /etc/rc.local > /dev/null; then
            echo "$line: Line already added"
        else
            sudo sed -i "s/^exit 0$/$line\nexit 0/" /etc/rc.local
            echo "Adding line $line"
        fi
    done
