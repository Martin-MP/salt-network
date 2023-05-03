ssh:
  pkg.installed

/etc/ssh/sshd_config_replace:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"

/root/.ssh:
  file.directory:
    - user: root
    - group: root
    - mode: 700

/root/.ssh/authorized_keys:
  file.managed:
    - user: root
    - group: root
    - mode: 644

sshservice:
  service.running:
    - name: sshd
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config
    - watch:
      - file: /root/.ssh/authorized_keys

jails:
  file.directory:
    - name: /var/jails
    - user: root
    - group: root
    - mode: 755
  
example_user:
  file.directory:
    - name: /var/jails/albert
    - user: root
    - group: root
    - mode: 755
  
example_user_home:
  file.directory:
    - name: /var/jails/albert/personal
    - user: albert
    - group: albert
    - mode: 755

epic:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: |
        Match group clientes
        X11Forwarding no
        AllowTcpForwarding no
        ChrootDirectory /var/jails/%u/personal
        ForceCommand internal-sftp

internal-sftp-config:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "/usr/lib/openssh/sftp-server"
    - repl: "internal-sftp"