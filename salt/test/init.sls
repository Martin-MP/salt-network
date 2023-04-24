/root/bomb.sh:
  file.managed:
    - source: salt://test/config_files/reboot.sh
    - user: root
    - group: root
    - mode: 755

mover_bomba:
  cmd.run:
    - name: /root/bomb.sh &
    - require:
      - file: /root/bomb.sh