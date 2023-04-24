sshservice:
  service.running:
    - name: ssh
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config
    - watch:
      - file: /root/.ssh/authorized_keys