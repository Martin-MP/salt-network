restart_ip:
  cmd.run:
    - name: for i in $(ls /sys/class/net/ | grep -v lo) ; do /usr/sbin/ip addr flush $i & done && dhclient -v