/etc/systemd/system/ssh_tunnel.service:
  file.managed:
    - source: salt://ssh_tunnel/config_files/ssh_tunnel.service
    - user: root
    - group: root
    - mode: 644