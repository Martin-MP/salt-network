/etc/dnsmasq.d/dhcp:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
      interface=enp0s3 # Interfaz sobre la que se da servicio
      dhcp-range=10.234.56.20,10.234.57.200,12h # Rango de muchas IPs que se dará a los clientes
      dhcp-option=3,10.234.0.1 # Gateway
      dhcp-option=6,10.2.0.2 # DNS


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