{% from "system_monitor/map.jinja" import sysmonitor with context %}
{# sysmonitor.file means absolute path /root/bin/systemmonitor2.sh #}


{{ sysmonitor.filepath }}:
  file.directory:
    - user: {{ sysmonitor.user }}
    - group: {{ sysmonitor.group }}
    - mode: 755


{{ sysmonitor.filepath }}/{{ sysmonitor.filename }}:
  file.managed:
    - source: salt://system_monitor/files/{{ sysmonitor.filename }}
    - user: {{ sysmonitor.user }}
    - group: {{ sysmonitor.group }}
    - mode: 755
    - template: jinja


{% for arg,value in sysmonitor.args.items() %}
cron_job_{{ arg }}:
  cron.present:
    - name: {{ sysmonitor.filepath }}/{{ sysmonitor.filename }} {{ arg }}
    - job_args: {{ arg }}
    - identifier: {{ arg }}
    - minute: '{{ sysmonitor.minute | default('*') }}'
    - hour: '{{ sysmonitor.hour | default('*') }}'
    - daymonth: '{{ sysmonitor.daymonth | default('*') }}'
    - month: '{{ sysmonitor.month | default('*')  }}'
    - dayweek: '{{ sysmonitor.dayweek | default('*') }}'
    - comment: 'Installed via Salt'
{% endfor %}
