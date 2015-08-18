{% from "install_nginx/map.jinja" import nginx as nginx_map with context %}

include:
  - nginx.common
  - nginx.package

