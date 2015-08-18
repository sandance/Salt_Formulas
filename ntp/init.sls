{% from "ntp/map.jinja" import ntp with context %}

ntp:
  pkg.installed:
    - skip_verify: True
    - skip_suggestions: True
    - refresh: True
    - pkgs:
      - {{ ntp.client }}
      - {{ ntp.ntpdate }}
      - {{ ntp.ntp_doc }}


{{ ntp.ntp_conf }}:
  file.managed:
    - template: jinja
    - source: salt://ntp/template/ntp.conf
    - require: 
      - pkg: ntp

ntpd:
  service.running:
    - name: {{ ntp.service }}
    - enable: True
    - require:
      - pkg: ntp
    - watch:
      - file: {{ ntp.ntp_conf }}
