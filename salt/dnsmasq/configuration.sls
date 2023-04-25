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

/etc/.ssh:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/.ssh/id_rsa:
  file.managed:
    - source: salt://keys/dnsmasq/private
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: ssh

/etc/.ssh/authorized_keys:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh

/root/.ssh/authorized_keys:
  file.append:
    - text: {{ salt['cp.get_file_str']('salt://keys/salt-master/public') }}
    - require:
      - pkg: ssh