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

/etc/ssh/sshd_config:
  file.append:
    - text: |
        Match group clientes
        X11Forwarding no
        AllowTcpForwarding no
        ChrootDirectory %h
  file.replace:
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"

create_certificate:
  cmd.run:
    - name: openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=ES/ST=Denial/L=Castefa/O=Dis/CN=www.espanyol.co.uk" -keyout /etc/apache2/certificate/apache2.key -out /etc/apache2/certificate/apache2.cert