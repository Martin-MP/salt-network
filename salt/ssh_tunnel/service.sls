create_ssh_tunnel:
  module.run:
    - name: ssh_reverse_tunnel.create_ssh_tunnel
    - port: 2222
    - remote_host: 172.31.2.6
    - username: alumnat
    - private_key_file: <path-to-private_key_file>