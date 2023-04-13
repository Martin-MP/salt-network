/etc/openvpn/server.conf:
  file.managed:
    - source: salt://vpn/config_files/server.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn

/etc/sysctl.conf:
  file.managed:
    - source: salt://vpn/config_files/sysctl.conf
    - user: root
    - group: root
    - mode: 644

/etc/nftables.conf:
  file.managed:
    - source: salt://vpn/config_files/nftables.conf
    - user: root
    - group: root
    - mode: 644

/root/new_vpn_client.sh:
  file.managed:
    - source: salt://vpn/config_files/new_vpn_client.sh
    - user: root
    - group: root
    - mode: 755