/etc/dnsmasq.d/dhcp:
  file.managed:
    - source: salt://dnsmasq/config_files/dhcp
    - user: root
    - group: root
    - mode: 644
#    - require:
#      - pkg: dnsmasq

/etc/dnsmasq.d/dns:
  file.managed:
    - source: salt://dnsmasq/config_files/dns
    - require:
      - pkg: dnsmasq

/etc/.ssh/id_rsa:
  file.managed:
    - source: salt://keys/dnsmasq/dnsmasq
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: ssh