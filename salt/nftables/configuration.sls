/etc/sysctl.conf:
  file.managed:
    - source: salt://nftables/config_files/sysctl.conf
    - user: root
    - group: root
    - mode: 644

/etc/nftables.conf:
  file.managed:
    - source: salt://nftables/config_files/nftables.conf
    - user: root
    - group: root
    - mode: 644

/etc/.ssh:
  file.directory:
    - user: root
    - group: root
    - mode: 755

vpn_public_key:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://keys/vpn/vpn.pub
    - mode: 644