{% from "python/map.jina" import python3 with context %}

python3:
  pkg.installed:
    - name: {{ python3.python3.pkg }}

python3-dev:
  pkg.installed:
    - name: {{ python3.python3.dev_pkg }}

python3-pip:
  pkg.installed:
    - name: {{ python3.python3.pip_pkg }}
