base:
  '*':
    - vim
  'dhcp-dns-minion':
    - dhcp_dns
  'webtest':
    - webserver
  'webhost':
    - webserver
  'VPNVirgin':
    - easyrsa
    - vpn
  'vpnserver':
    - ssh_tunnel
