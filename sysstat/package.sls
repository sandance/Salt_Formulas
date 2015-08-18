{## import settings from map.jinja ##}
{% from "sysstat/map.jinja" import sysstat_settings with context %}

systat-pkg:
  pkg.installed:
    - name: {{ sysstat_settings.pkg }}
    - failhard: True
