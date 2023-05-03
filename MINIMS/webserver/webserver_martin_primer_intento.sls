apache2:
  pkg.installed

openssl:
  pkg.installed

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

internal-sftp-config:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "/usr/lib/openssh/sftp-server"
    - repl: "internal-sftp"

create_certificate:
  cmd.run:
    - name: openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=ES/ST=Denial/L=Castefa/O=Dis/CN=www.espanyol.co.uk" -keyout /etc/apache2/certificate/apache2.key -out /etc/apache2/certificate/apache2.cert

salt_master_public_key:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://salt-master.pub
    - mode: 644

create_easynoob_directory:
    file.directory:
        - name: /var/www/easynoob.com
        - user: root
        - group: root
        - mode: 755

create_vhost_conf:
  file.managed:
    - name: /etc/apache2/sites-available/easynoob.com.conf
    - text: |
        <VirtualHost *:80>
            ServerName easynoob.com
            ServerAlias www.easynoob.com
            DocumentRoot /var/www/easynoob.com
            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined
            SSLEngine on
            SSLCertificateFile /etc/apache2/certificate/apache2.cert
            SSLCertificateKeyFile /etc/apache2/certificate/apache2.key
        </VirtualHost>
    - mode: 644

create_easynoob_webpage:
  file.managed:
    - name: /var/www/easynoob.com/index.html
    - text: |
        <html>
            <head>
                <title>www.easynoob.com</title>
            </head>
            <body>
                <h1>Benbingut a easynoob.com</h1>
            </body>
        </html>

start_apache:
  cmd.run:
    - name: a2enmod ssl; a2enmod rewrite ; systemctl restart apache2
    - require:
      - pkg: apache2

enable_easynoob:
  cmd.run:
    - name: a2ensite easynoob.com.conf
    - require:
      - file: /etc/apache2/sites-available/easynoob.com.conf

apache2.service:
  service.running:
    - enable: True

ssh_service_sshd_config:
  service.running:
    - name: ssh
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config