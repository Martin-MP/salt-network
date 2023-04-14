start_apache:
  cmd.run:
    - name: a2enmod ssl
    - name: a2enmod rewrite
    - require:
      - pkg: apache2

/etc/apache2/certificate:
  file.directory:
    - user: root
    - group: root
    - mode: 755

create_certificate:
  cmd.run:
    - name: openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=ES/ST=Denial/L=Castefa/O=Dis/CN=www.espanyol.co.uk" -keyout /etc/apache2/certificate/apache2.key -out /etc/apache2/certificate/apache2.cert