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