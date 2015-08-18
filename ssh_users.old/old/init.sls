{% set users = salt['pillar.get']('ssh_users:lookup',{}) %}
{% set groups = salt['pillar.get']('ssh_users:ssh_groups',{}) %}


{% for id, g in groups | dictsort %}
  {% set name = g.name | default(id) %}

group_{{ name }}:
  group.{{ g.state }}:
    - gid: {{ g.gid }}
    - system: {{ g.system }}
    - members:
    {% for member in g.members %}
      - {{ member }}
    {% endfor %}
{% endfor %}

{% for id,user in users | dictsort %}
  {% set name = user.name | default(id) %}
  
user_{{ name }}:
  user.{{ user.state }}:
    - name: {{ name }}
    - fullname: {{ user.fullname }}
    - home: {{ user.home }}
    - shell: {{ user.shell }}
    - groups:
      {% for group in user.groups %}
        - {{ group }}
      {% endfor %}


user_{{ name }}_sshdr:
  file.directory:
    - name: {{ user.shell }}/.ssh
    - mode: 700
    - user: {{ name }}
    - group: {{ name }}
    - uid: {{ user.uid }}
    - require:
      - user: user_{{ name }}

ssh_key_{{ name }}:
  ssh_auth:
    - present
    - user: {{ name }}
    - names:
      - {{ user.shell }}/.ssh/{{ user.pub_key }}
    - require:
      - user_{{ name }}_sshdr
{% endfor %}
