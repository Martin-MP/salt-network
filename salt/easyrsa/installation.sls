easy-rsa:
  pkg.installed:
    - name: easy-rsa
    - unless: ls /usr/share/easy-rsa/easyrsa

#/etc/openvpn/easy-rsa:
#  file.directory:
#    - user: root
#    - group: root
#    - mode: 750
#/usr/share/easy-rsa:
#  archive.extracted:
#    - source: https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz
#    - archive_format: tar
#    - user: root
#    - group: root
#    - mode: 750
#    - unless: ls /usr/share/easy-rsa/easyrsa