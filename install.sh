#!/bin/bash
cd $HOME
wget -N https://raw.githubusercontent.com/5high/Pcap_DNSProxy/master/install.sh
chmod +x install.sh
bash install.sh
wget -N https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/install-without-dns.sh
chmod +x install-without-dns.sh
bash install-without-dns.sh
wget -N https://install.direct/go.sh
chmod +x go.sh
bash go.sh
cd /etc
wget -N https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/rc.local
cd /etc/v2ray
wget -N https://raw.githubusercontent.com/5high/Pi-USB-NIC/master/config.json
systemctl restart v2ray
cd $HOME
rm -rf install.sh
rm -rf install-without-dns.sh
rm -rf go.sh
