dnsmasq:
  pkg.installed

/etc/dnsmasq.d/dhcp:
  file.managed:
    - source: salt://dhcp
    - user: root
    - group: root
    - mode: 644

salt_master_public_key:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://salt-master.pub
    - mode: 644

dnsmasq.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/dnsmasq.d/dhcp