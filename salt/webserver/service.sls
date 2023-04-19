start_apache:
  cmd.run:
    - name: systemctl restart apache2
    #- name: a2enmod ssl
    #- name: a2enmod rewrite
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