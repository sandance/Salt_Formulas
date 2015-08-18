{% from "cron/default.yaml" import rawmap_osfam with context %}
{% set datamap = salt['grains.filter_by'] (rawmap_osfam, merge=salt['pillar.get']('cron:lookup')) %}


{% set jobs = datamap.jobs | default({}) %}
{% for k,v in jobs | dictsort %}
cron_job_{{ k }}:
  cron:
    - {{ v.ensure|default('present') }}
    - name: {{ v.cmd }}
    - user: {{ v.user }}
    - identifier: {{ k }}
    - minute: {{ v.minute|default('*') }}
    - daymonth: {{ v.daymonth|default('*') }}
    - month: {{ v.month|default('*') }}
    - dayweek: {{ v.dayweek|default('*') }}
  {% if 'user' in v %}
    - user: {{ v.user }}
  {% endif %}
  {% if 'comment' in v %}
    - comment: {{ v.comment }}
  {% endif %}
{% endfor %}

