/etc/openvpn/server.conf:
  file.managed:
    - source: salt://vpn/config_files/server.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn

/etc/openvpn/easy-rsa/vars:
  file.managed:
    - source: salt://vpn/config_files/vars
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn

/etc/openvpn/easy-rsa/pki:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: openvpn