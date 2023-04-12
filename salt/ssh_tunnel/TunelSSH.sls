create_ssh_tunnel:
  module.run:
    - name: ssh_reverse_tunnel.create_ssh_tunnel
    - port: 2222
    - remote_host: <remote_host>
    - username: <username>
    - private_key_file: <path-to-private_key_file>