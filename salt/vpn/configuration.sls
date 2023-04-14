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

/etc/openvpn:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/openvpn/easy-rsa:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/openvpn/easy-rsa/keys:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/openvpn/easy-rsa/keys/ca.crt:
  file.managed:
    - source: /root/pki/ca.crt
    - user: root
    - group: root
    - mode: 644

/etc/openvpn/easy-rsa/keys/dh.pem:
  file.managed:
    - source: /root/pki/dh.pem
    - user: root
    - group: root
    - mode: 644

/etc/openvpn/easy-rsa/keys/vpnserver.crt:
  file.managed:
    - source: /root/pki/issued/vpnserver.crt
    - user: root
    - group: root
    - mode: 644

/etc/openvpn/easy-rsa/keys/vpnserver.key:
  file.managed:
    - source: /root/pki/private/vpnserver.key
    - user: root
    - group: root
    - mode: 644