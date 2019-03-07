#!/bin/bash
#修改国内apt源
#echo -e "\033[32m正在安装Pcap_DNSProxy\033[0m"
#bash <(curl -L -s https://bit.ly/2SCRuXf)
echo -e "\033[32m正在修改apt源\033[0m"
sudo echo 'deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi' > /etc/apt/sources.list
sudo echo 'deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi' >> /etc/apt/sources.list
sudo echo 'deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui' > /etc/apt/sources.list.d/raspi.list
sudo echo 'deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui' >> /etc/apt/sources.list.d/raspi.list
sudo apt-get update
#开启ip4转发
echo -e "\033[32m正在开启ipv4 forward\033[0m"
sudo sysctl -w net.ipv4.ip_forward=1
#开启nat
echo -e "\033[32m正在开启nat\033[0m"
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
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
port=53
strict-order
cache-size=1500
conf-dir=/etc/dnsmasq.d
#DHCP
no-ping
dhcp-authoritative
dhcp-option=3,192.168.137.100
dhcp-option=6,192.168.137.100
dhcp-lease-max=50
dhcp-leasefile=/tmp/dnsmasq.leases
interface=usb0
dhcp-range=192.168.137.200,192.168.137.250,12h' > /etc/dnsmasq.conf

echo -e "\033[32m正在启动dnsmasq\033[0m"
sudo systemctl start dnsmasq

#增加开机启动
lines=(
    'echo 1 > \/proc\/sys\/net\/ipv4\/ip_forward'
    'iptables -t nat -A POSTROUTING -j MASQUERADE'

    )
    
    for line in "${lines[@]}"; do
        if grep "$line" /etc/rc.local > /dev/null; then
            echo "$line: Line already added"
        else
            sudo sed -i "s/^exit 0$/$line\nexit 0/" /etc/rc.local
            echo "Adding line $line"
        fi
    done
#开启bbr加速
echo -e "\033[32m正在开启bbr加速\033[0m"
bash <(curl -L -s https://github.com/teddysun/across/raw/master/bbr.sh)

echo -e "\033[32m安装完成，建议重启树莓派！\033[0m"
