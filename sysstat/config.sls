{## import settings from map.jinja ##}
{% from "sysstat/map.jinja" import sysstat_settings with context %}
{% set config_settings = sysstat_settings.config %}

sysstat-config:
  file.managed:
    - name: {{ config_settings.path }}
    - source: salt://sysstat/files/sysstat.default
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      enabled: "{{ config_settings.enabled }}"
    {% if sysstat_settings.service.enabled %}
    - listen_in:
      - service: sysstat-service
    {% endif %}
