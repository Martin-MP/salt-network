base:
  '*':
    - vim
  'nftables*':
    - nftables
  'dnsmasq*':
    - dhcp_dns
  'webhost*':
    - webserver
  'vpn*':
    - easyrsa
    - vpn
    - ssh_tunnel
