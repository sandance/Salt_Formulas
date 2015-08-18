{% from "python/map.jinja" import python with context %}
pip:
  pkg.installed:
    - name: {{ python.pip_pkg }}

