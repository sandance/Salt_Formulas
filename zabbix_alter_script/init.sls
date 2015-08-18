
/etc/zabbix/scripts/:
  file.directory:
    - user: root
    - group: zabbix
    - mode: 755

/etc/zabbix/scripts/celery_beat_checker.sh:
    file.managed:
      - source: salt://zabbix_alter_script/files/celery_beat_checker.sh
      - user: zabbix
      - group: zabbix
      - mode: 777

zabbix-agent:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/zabbix/scripts/celery_beat_checker.sh
    - require:
      - file: /etc/zabbix/scripts/celery_beat_checker.sh


### Adding nginx zabbix file ###

/etc/zabbix/scripts/nginx-stats.sh:
  file.managed:
    - source: salt://zabbix_alter_script/files/nginx-stats.sh
    - user: zabbix
    - group: zabbix
    - mode: 755

nginx:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/zabbix/scripts/nginx-stats.sh
    - require:
      - file: /etc/zabbix/scripts/nginx-stats.sh


