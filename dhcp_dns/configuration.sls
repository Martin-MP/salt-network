/etc/dnsmasq.d/dhcp:
  file.managed:
    - source: salt://dhcp_dns/config_files/dhcp
    - require:
      - pkg: dnsmasq

/etc/dnsmasq.d/dns:
  file.managed:
    - source: salt://dhcp_dns/config_files/dns
    - require:
      - pkg: dnsmasq
