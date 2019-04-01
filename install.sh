#!/bin/bash
sudo su
bash <(curl -L -s https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/install-without-dns.sh)
bash <(curl -L -s https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/install-without-dns.sh)
bash <(curl -L -s https://install.direct/go.sh)
cd /etc
wget -N https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/rc.local
wget -N https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/config.json
systemctl restart v2ray
