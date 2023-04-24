dnsmasq.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/dnsmasq.d/dhcp
      - file: /etc/dnsmasq.d/dns