nftables:
  pkg.installed

/etc/sysctl.conf:
  file.managed:
    - source: salt://sysctl.conf
    - user: root
    - group: root
    - mode: 644

/etc/nftables.conf:
  file.managed:
    - source: salt://nftables.conf
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
    - source: salt://vpn.pub
    - mode: 644

nftables.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/nftables.conf

reset_sysctl:
  cmd.run:
    - name: sysctl -p