{% from "python/map.jinja" import python with context %}
python:
  pkg.installed:
    - name: {{ python.pkg }}

