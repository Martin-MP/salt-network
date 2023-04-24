reload_services:
  cmd.run:
    - name: systemctl daemon-reload

ssh_tunnel.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/ssh_tunnel.service