init_pki:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch init-pki

build_ca:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch build-ca nopass

build_dh:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch gen-dh

vpn_gen_req:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch gen-req vpnserver nopass

vpn_sign_req:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch sign-req server vpnserver

client1_gen_req:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch gen-req client1 nopass

client1_sign_req:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa --batch sign-req client client1

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