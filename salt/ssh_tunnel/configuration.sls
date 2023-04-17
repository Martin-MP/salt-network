/etc/systemd/system/ssh_tunnel.service:
  file.managed:
    - source: salt://ssh_tunnel/config_files/ssh_tunnel.service
    - user: root
    - group: root
    - mode: 644

/root/.ssh:
  file.directory:
    - user: root
    - group: root
    - mode: 700

/root/.ssh/tunnel_key:
  file.managed:
    - source: salt://ssh_tunnel/config_files/tunnel_key
    - user: root
    - group: root
    - mode: 700