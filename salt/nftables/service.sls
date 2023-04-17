nftables.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/nftables.conf

reset_sysctl:
  cmd.run:
    - name: sysctl -p