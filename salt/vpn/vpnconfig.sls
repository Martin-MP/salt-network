/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/server.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/openvpn/easy-rsa/vars:
  file.managed:
    - source: salt://openvpn/easy-rsa/vars
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/openvpn/easy-rsa/pki:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/openvpn/easy-rsa/Makefile:
  file.managed:
    - source: salt://openvpn/easy-rsa/Makefile
    - user: root
    - group: root
    - mode: 644
    - template: jinja
