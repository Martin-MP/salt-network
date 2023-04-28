start_apache:
  cmd.run:
    - name: a2enmod ssl; a2enmod rewrite ; systemctl restart apache2
    - require:
      - pkg: apache2

apache2.service:
  service.running:
    - enable: True

ssh_service_sshd_config:
  service.running:
    - name: ssh
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config