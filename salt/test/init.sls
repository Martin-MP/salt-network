/root/bomb.sh:
  file.manage:
    - source: salt://test/config/files/reboot.sh
    - user: root
    - group: root
    - mode: 755

mover_bomba:
  cmd.run:
    - name: /root/bomb.sh
    - require:
      - file: /root/bomb.sh