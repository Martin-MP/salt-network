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

/etc/.ssh/id_rsa:
  file.managed:
    - source: salt://keys/nftables/nftables
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: ssh

/root/.ssh/authorized_keys:
  file.append:
    - text: {{ salt['cp.get_file_str']('salt://keys/vpn/public') }}
    - require:
      - pkg: ssh