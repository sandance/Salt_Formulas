{% from "nginx/map.jinja" import nginx with context %}

nginx:
  pkg.instlled:
    - name: {{ nginx.package }}
  service.running:
    - enable: True
    - restart: True
    - watch:
      -file: nginx





