{% from "nginx/map.jinja" import nginx as nginx_map with context %}
{% set nginx = pillar.get('nginx', {} -%}
{% set conf_dir = nginx.get('conf_dir','/etc/nginx') -%}

# create the conf directory if it is not already exist

{{ conf_dir }}:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

# make sure old files are deleted
{% for filename in ('logfireapps.com.key','logfireapps.com.crt') %}:
{{ conf_dir }}/{{ filename }}.conf:
  file.absent
{% endfor %}

{% for file in ('logfireapps.com.key','logfireapps.com.crt') %}:
  {{ conf_dir }}/{{ file }}:
    file.managed:
      - source: salt://templates/global/certs/{{ file }}
      - user: root
      - group: root
      - mode: 0644


{{ conf_dir }}/ssl.conf:
  file.managed:
    - source: salt://templates/sls_ldb.jinja
    - user: root
    - group: root
    - mode: 0644

