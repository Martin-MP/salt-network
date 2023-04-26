/etc/dnsmasq.d/dhcp:
  file.managed:
    - source: salt://dnsmasq/config_files/dhcp
    - user: root
    - group: root
    - mode: 644
#    - require:
#      - pkg: dnsmasq

/etc/dnsmasq.d/dns:
  file.managed:
    - source: salt://dnsmasq/config_files/dns
    - require:
      - pkg: dnsmasq

salt_master_public_key:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://keys/salt-master/salt-master.pub
    - mode: 644