dnsmasq:
  pkg.installed

/etc/dnsmasq.d/dhcp:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
      interface=enp0s3 # Interfaz sobre la que se da servicio
      dhcp-range=10.234.56.20,10.234.57.200,12h # Rango de muchas IPs que se dará a los clientes
      dhcp-option=3,10.234.0.1 # Gateway
      dhcp-option=6,10.2.0.2 # DNS

dnsmasq.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/dnsmasq.d/dhcp