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