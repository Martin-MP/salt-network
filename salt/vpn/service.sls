openvpn@server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/openvpn/server.conf

nftables:
  service.running:
    - enable: True
    - watch:
      - file: /etc/nftables.conf

reset_sysctl:
  cmd.run:
    - name: sysctl -p