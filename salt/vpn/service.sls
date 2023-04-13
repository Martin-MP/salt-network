openvpn@server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/openvpn/server.conf
