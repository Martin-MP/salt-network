/etc/openvpn/easy-rsa/pki:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa init-pki
    - creates: /etc/openvpn/easy-rsa/pki

/etc/openvpn/easy-rsa/pki/ca.crt:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa build-ca nopass
    - creates: /etc/openvpn/easy-rsa/pki/ca.crt

/etc/openvpn/easy-rsa/pki/server.req:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa gen-req vpnserver nopass
    - creates: /etc/openvpn/easy-rsa/pki/server.req

/etc/openvpn/easy-rsa/pki/server.crt:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa sign-req server vpnserver
    - creates: /etc/openvpn/easy-rsa/pki/server.crt

/etc/openvpn/easy-rsa/pki/client1.req:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa gen-req client1 nopass
    - creates: /etc/openvpn/easy-rsa/pki/client1.req

/etc/openvpn/easy-rsa/pki/client1.crt:
  cmd.run:
    - name: /usr/share/easy-rsa/easyrsa sign-req client client1
    - creates: /etc/openvpn/easy-rsa/pki/client1.crt
