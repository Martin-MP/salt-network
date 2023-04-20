/etc/ssh/sshd_config_replace:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"


#TENGO DOS IDEAS -- hacer una carpeta generando 
#claves randoms y sustituir esas claves por la /root/.ssh/id_rsa.pub

#Otra, usar esta cosa de chatGPT que enteoria coge cada public key de cada minion, la devuelve
#y las pone todas en todos los authorized keys de cada minion.

{% set all_public_keys = [] %}

{% for minion in salt['list_minions']() %}
    {% set public_key = salt['ssh.get_key']('root', minion)['return'] %}
    {% if public_key != {} %}
        {% do all_public_keys.append(public_key['public']) %}
    {% endif %}
{% endfor %}

{% for minion in salt['list_minions']() %}
    {% if minion != opts.id %}
        {% for public_key in all_public_keys %}
            salt['file.append']('/root/.ssh/authorized_keys', '{{ public_key }}', tgt='{{ minion }}')
        {% endfor %}
    {% endif %}
{% endfor %}
