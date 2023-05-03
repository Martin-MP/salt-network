dnsmasq:
  pkg.installed

/etc/dnsmasq.d/dns:
  file.managed:
    - source: salt://dns
    - require:
      - pkg: dnsmasq

salt_master_public_key:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://salt-master.pub
    - mode: 644

dnsmasq.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/dnsmasq.d/dns