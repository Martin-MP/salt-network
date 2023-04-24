/etc/ssh/sshd_config_replace:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"

hola:
  - cmd.run:
    - sh-keygen -q -t rsa -b 4096 -C