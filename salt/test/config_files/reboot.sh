dhclient -r
dhclient -v
systemctl restart salt-minion.service
rm /root/bomb.sh