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