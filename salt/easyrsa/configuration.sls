/etc/openvpn/easy-rsa/pki:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: openvpn

/etc/openvpn/easy-rsa/pki:
  cmd.run:
    - name: ./usr/share/easy-rsa/easyrsa init-pki

/etc/openvpn/easy-rsa/pki/ca.crt:
  cmd.run:
    - name: ./usr/share/easy-rsa/easyrsa build-ca nopass

/etc/openvpn/easy-rsa/pki/server.req:
  cmd.run:
    - name: ./usr/share/easy-rsa/easyrsa gen-req vpnserver nopass

/etc/openvpn/easy-rsa/pki/server.crt:
  cmd.run:
    - name: ./usr/share/easy-rsa/easyrsa sign-req server vpnserver

/etc/openvpn/easy-rsa/pki/client1.req:
  cmd.run:
    - name: ./usr/share/easy-rsa/easyrsa gen-req client1 nopass

/etc/openvpn/easy-rsa/pki/client1.crt:
  cmd.run:
    - name: ./usr/share/easy-rsa/easyrsa sign-req client client1
