/etc/dnsmasq.d/dhcp:
  file.managed:
    - source: salt://dhcp_dns/config_files/dhcp
    - user: root
    - group: root
    - mode: 644
#    - require:
#      - pkg: dnsmasq

/etc/dnsmasq.d/dns:
  file.managed:
    - source: salt://dhcp_dns/config_files/dns
    - require:
      - pkg: dnsmasq
