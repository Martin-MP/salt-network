base:
  '*':
    - vim
  'dhcp-dns-minion':
    - dhcp_dns
  'webtest':
    - webserver
  'webhost':
    - webserver
  'vpnvirgin5':
    - easyrsa
    - vpn
  'vpnserver':
    - ssh_tunnel
