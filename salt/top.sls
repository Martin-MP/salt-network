base:
  '*':
    - vim
  'dhcpdns':
    - dhcp_dns
  'webhost':
    - webserver
  'vpnserver':
    - easyrsa
    - vpn
    - ssh_tunnel
  'nftables':
    - nftables
#  'minion1':
#    - EstadoX
