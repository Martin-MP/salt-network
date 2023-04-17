dnsmasq.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/dnsmasq.d