apache2.service:
  service.running:
    - enable: True

start_apache:
  cmd.run:
    - name: a2enmod ssl
    - name: a2enmod rewrite
    - name: systemctl restart apache2
    - require:
      - pkg: apache2

ssh.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config