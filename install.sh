#!/bin/bash#修改国内apt源
echo -e "\033[32m正在修改apt源\033[0m"sudo echo 'deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi' > /etc/apt/sources.listsudo 
echo 'deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi' >> /etc/apt/sources.listsudo 
echo 'deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui' > /etc/apt/sources.list.d/raspi.listsudo 
echo 'deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui' >> /etc/apt/sources.list.d/raspi.list
sudo apt-get update
#开启ip4转发
echo -e "\033[32m正在开启ipv4 forward\033[0m"
sudo sed -i '/net.ipv4.ip_forward/ s/\(.*= \).*/\11/' /etc/sysctl.conf
#开启nat
echo -e "\033[32m正在开启nat\033[0m"
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables-save
#固定USB0网卡ip地址
echo -e "\033[32m正在设置USB网卡IP地址\033[0m"
sudo echo '#!/bin/bash' > /etc/network/if-up.d/usb0
sudo echo 'sudo ifconfig usb0 192.168.137.100' >> /etc/network/if-up.d/usb0
sudo chmod +x /etc/network/if-up.d/usb0
#安装配置dnsmasq
echo -e "\033[32m正在安装dnsmasq\033[0m"
sudo apt-get install dnsmasq -y
sudo systemctl enable dnsmasq
echo -e "\033[32m正在安装dnsmasq\033[0m"
sudo echo '
# DNS
DNSMASQ_OPTS="-p0"
strict-order
cache-size=1500
conf-dir=/etc/dnsmasq.d
#DHCP
no-ping
dhcp-authoritative
dhcp-option=3,192.168.137.100
dhcp-lease-max=50
dhcp-leasefile=/tmp/dnsmasq.leases
interface=usb0
dhcp-range=192.168.137.200,192.168.137.250,12h' > /etc/dnsmasq.conf

echo -e "\033[32m正在启动dnsmasq\033[0m"
sudo systemctl restart dnsmasq

#安装V2ray
#sudo wget https://install.direct/go.sh
#sudo /bin/bash go.sh
#修改V2ray客户端配置文件 inbounds 增加如下代码，其余部分保持不变
#"inbounds": [{# "domainOverride": ["tls", "http"],
# "listen": "0.0.0.0",
# "port": 12345,
# "protocol": "dokodemo-door",
# "settings": {
# "followRedirect": true
# },
# "streamSettings": {
# "sockopt": {
# "mark": 100,
# "tcpFastOpen": true,# "tproxy": "tproxy"# }
# }
# }]
#V2ray设置透明代理
#设置iptable 送流量给V2ray的Dokodemo Door
#GW=`netstat -rn|grep '0.0.0.0'|awk '{print $2}'|head -1`HOST_IP=$(ifconfig |grep broadcast |awk '{print $2}')
#sudo ip rule add fwmark 0x01/0x01 table 100
#sudo ip route add local 0.0.0.0/0 dev lo table 100
#sudo iptables -t mangle -N V2RAYsudo iptables -t mangle -I V2RAY -d 192.168.0.0/16 -j RETURN
#sudo iptables -t mangle -I V2RAY -d $GW/32 -j RETURN
#for line in $HOST_IP do
#echo $line
#sudo iptables -t mangle -I V2RAY -d $line/32 -j RETURN
#done
#sudo iptables -t mangle -I V2RAY -d 127.0.0.1/32 -j RETURN
#sudo iptables -t mangle -A V2RAY -p udp -j TPROXY --on-port 12345 --tproxy-mark 0x01/0x01
#sudo iptables -t mangle -A V2RAY -p tcp -j TPROXY --on-port 12345 --tproxy-mark 0x01/0x01
#sudo iptables -t mangle -A PREROUTING -j V2RAYsudo iptables-save > /etc/iptables.ipv4.nat
#增加开机启动sudo iptables-restore < /etc/iptables.ipv4.nat
