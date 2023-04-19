/etc/apache2/certificate:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/apache2/apache2.conf_append:
  file.append:
    - name: /etc/apache2/apache2.conf
    - text: |
        <Directory /var/www/>
            AllowOverride All
        </Directory>

/etc/ssh/sshd_config_append:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: |
        Match group clientes
        X11Forwarding no
        AllowTcpForwarding no
        ChrootDirectory /var/www/%u
        ForceCommand internal-sftp

/etc/ssh/sshd_config_replace:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"

/etc/ssh/sshd_config_replace2:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "/usr/lib/openssh/sftp-server"
    - repl: "internal-sftp"

/root/internal_newhosting.sh:
  file.managed:
    - source: salt://webserver/config_files/internal_newhosting.sh
    - user: root
    - group: root
    - mode: 755

create_certificate:
  cmd.run:
    - name: openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=ES/ST=Denial/L=Castefa/O=Dis/CN=www.espanyol.co.uk" -keyout /etc/apache2/certificate/apache2.key -out /etc/apache2/certificate/apache2.cert
    - name: a2enmod ssl
    - name: a2enmod rewrite