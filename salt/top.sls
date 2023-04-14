base:
  '*':
    - vim
  'dhcp-dns-minion':
    - dhcp_dns
  'webtest':
    - webserver
  'webhostvirgin':
    - webserver
  'vpnvirgin5':
    - easyrsa
    - vpn
  'vpnserver':
    - ssh_tunnel
  'nftablesvirgin':
    - nftables
