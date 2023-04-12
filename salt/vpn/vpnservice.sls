openvpn:
  service.running:
    - name: openvpn
    - watch:
      - file: /etc/openvpn/server.conf
