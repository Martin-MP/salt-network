/etc/systemd/system/ssh_tunnel.service:
  file.managed:
    - source: salt://ssh_tunnel/config_files/ssh_tunnel.service
    - user: root
    - group: root
    - mode: 644

/root/.ssh/tunnel_key:
  file.managed:
    - source: salt://ssh_tunnel/config_files/tunnel_key
    - user: root
    - group: root
    - mode: 700

open_tunnel:
  cmd.run:
    - name: ssh -i /root/.ssh/tunnel_key -NR 2222:localhost:22 root@172.31.2.6