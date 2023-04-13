/etc/openvpn/server.conf:
  file.managed:
    - source: salt://vpn/config_files/server.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn