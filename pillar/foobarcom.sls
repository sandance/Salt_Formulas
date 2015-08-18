{% if pillar.get('webserver_role','') %}
/var/www/foobarcom:
  file.rescue:
    - source: salt://webserver/src/foobarcom
    - env: {{ pillar['webserver_role'] }}
    - user: www
    - group: www
    - dir_mode: 755
    - file_mode: 644
{% endif %}
