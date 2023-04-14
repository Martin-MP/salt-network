apache2.service:
  service.running:
    - enable: True

ssh.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config