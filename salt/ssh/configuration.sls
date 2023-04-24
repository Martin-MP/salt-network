{% set minion = 'dhcp-minion' %}

# Generar la clave pública y privada en el minion remoto
ssh.gen_key:
  - user: root
  - bits: 4096
  - type: rsa
  - comment: 'Salt generated key'
  - target: {{ minion }}

# Obtener la clave pública del minion remoto
{% set public_key = salt['ssh.get_key']('root', minion)['return']['public'] %}

# Guardar la clave pública en un archivo en el master
{% set key_file = '/tmp/minion1.pub' %}
{% if public_key is defined %}
  {{ public_key }} > {{ key_file }}
{% endif %}

# Agregar la clave pública a los archivos authorized_keys en todos los minions
{% set minions = salt.list_all() %}
{% for m in minions %}
  {% if m != minion %}
    salt['file.append']('/root/.ssh/authorized_keys', salt['file.read'](key_file), tgt='{{ m }}')
  {% endif %}
{% endfor %}
