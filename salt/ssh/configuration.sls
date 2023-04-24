/etc/ssh/sshd_config_replace:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"

build_ca:
  cmd.run:
    - name: ssh-keygen -t rsa -b 4096 -C