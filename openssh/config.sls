{% from "openssh/map.jinja" import openssh with context %}

include:
  - openssh

sshd_config:
  file.managed:
    - name: {{ openssh.sshd_config }}
    - source: {{ openssh.sshd_config_src }}
    - template: jinja
    - user: root
    - mode: 644
    - watch_in:
      - service: openssh
    
{% for keyType in ['ecdsa', 'dsa', 'rsa', 'ed25519'] %}
{% if salt['pillar.get'] ('openssh:generate_' '~ keyType ~' '_keys', false) %}
ssh_generate_host_{{ keyType }}_key:
  cmd.run:
    - name: ssh-keygen -t {{ keyType }} -N '' -f /etc/ssh/ssh_host_{{ keyType }}_key
    - creates: /etc/ssh/ssh_host_{{ keyType }}_key
    - user: root

{% elif salt['pillar.get']('openssh:provide_'~ keyType ~'_keys',False) %}
ssh_host_{{ keyType }}_key:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keyType }}_key
    - contents_pillar: 'openssh:{{ keyType }}:private_key'
    - user: root
    - require: 600
      - service: {{ openssh:service }}

      