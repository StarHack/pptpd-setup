#!/bin/bash

# Check if required command line tools are installed
command -v apt-get >/dev/null 2>&1 || { echo >&2 "REQUIRED: apt-get"; exit 1; };
command -v update-rc.d >/dev/null 2>&1 || { echo >&2 "REQUIRED: update-rc.d (Debian based distribution)"; exit 1; };
command -v sysctl >/dev/null 2>&1 || { echo >&2 "REQUIRED: sysctl"; exit 1; };
command -v iptables >/dev/null 2>&1 || { echo >&2 "REQUIRED: iptables"; exit 1; };

# Install PPTPD
if [ "$1" == "install" ]; then
  # Install PPTPD Package
  apt-get install pptpd -y --force-yes

  # Configure server ip (localip) and client ip pool (remoteip)
  echo "localip 192.168.1.5" >> /etc/pptpd.conf
  echo "remoteip 192.168.1.234-238,192.168.1.245" >> /etc/pptpd.conf

  # Additional config such as nameserver, mtu size etc
  echo "ms-dns 77.88.8.8" >> /etc/ppp/pptpd-options
  echo "nobsdcomp" >> /etc/ppp/pptpd-options
  echo "noipx" >> /etc/ppp/pptpd-options
  echo "mtu 1490" >> /etc/ppp/pptpd-options
  echo "mru 1490" >> /etc/ppp/pptpd-options

  # Username/Password configuration (don't forget to edit)
  echo "username * password *" >> /etc/ppp/chap-secrets

  # Restart server to reload config
  /etc/init.d/pptpd restart

  # Automatically enable ipv4 forwarding and nat masquerading on reboot
  echo "sysctl -w net.ipv4.ip_forward=1" > /etc/init.d/vpnScript
  echo "iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE" >> /etc/init.d/vpnScript
  chmod +x /etc/init.d/vpnScript
  update-rc.d vpnScript defaults
elif [ "$1" == "remove" ]; then
  apt-get remove --purge pptpd -y --force-yes
  rm /etc/pptpd.conf
  rm /etc/ppp/pptpd-options
  rm /etc/ppp/chap-secrets
  update-rc.d vpnScript remove
  rm /etc/init.d/vpnScript
else
  echo "Usage: pptpSetup.sh [install|remove]"
fi