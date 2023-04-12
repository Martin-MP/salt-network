/root/.ssh/tunnel_key:
  file.managed:
    - source: salt://ssh_tunnel/config_files/tunnel_key
    - require:
      - pkg: openvpn

open_tunnel:
  cmd.run:
    - name: ssh -NR 8080:localhost:22 root@172.31.2.6