/root/.ssh/tunnel_key:
  file.managed:
    - source: salt://ssh_tunnel/config_files/tunnel_key
    - user: root
    - group: root
    - mode: 644
#    - require:
#      - pkg: openvpn

open_tunnel:
  cmd.run:
    - name: ssh -NR 2222:localhost:22 root@172.31.2.6