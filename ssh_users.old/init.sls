{% set users = salt['pillar.get']('ssh_users:lookup') %}

{% for name ,user in users %}

{{ name }}:
  {% set groups = user.groups | default(['sudo']) %}
  user.{{ user.state }}:
    - fullname: {{ user.fullname }}
    - home: /home/{{ name }}
    - shell: /bin/bash
    - groups:
      {% for group in groups %}
        - {{ group }}
      {% endfor %}
    {% if user.state == 'present' %}
  ssh_key_{{ name }}:
    ssh_auth:
      - present
      - user: {{ name }}
      - names:
        - {{ user.pub_key }}
      - require:
        - {{ name }}
    {% endif %}
{% endfor %}



