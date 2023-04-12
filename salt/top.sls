base:
  '*':
    - vim
  'dhcp-dns-minion':
    - dhcp_dns
  'webtest':
    - webserver
  'webhost':
    - webserver
  'vpnserver':
    - ssh_tunnel