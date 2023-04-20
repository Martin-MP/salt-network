/etc/ssh/sshd_config_replace:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "#PermitRootLogin prohibit-password"
    - repl: "PermitRootLogin yes"

{% for minion in salt['list_minions']() %}
    ssh-keygen -q -t rsa -b 4096 -C "{{ minion }} key" -f /root/.ssh/id_rsa -N "" <<< y
{% endfor %}

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