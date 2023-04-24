start_apache:
  cmd.run:
    - name: a2enmod ssl; a2enmod rewrite ; systemctl restart apache2
    - require:
      - pkg: apache2

apache2.service:
  service.running:
    - enable: True

ssh.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config