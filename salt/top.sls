base:
  '*':
    - vim
  'dhcp-dns-minion':
    - dhcp_dns
  'webtest':
    - webserver
  'web0':
    - webserver
  'vpnvirgin5':
    - easyrsa
    - vpn
  'vpnserver':
    - ssh_tunnel
  'nftablesvirgin':
    - nftables
