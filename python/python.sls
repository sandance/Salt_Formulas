{% from "python/map.jinja" import python2 with context %}

python2:
  pkg.installed:
    - name: {{ python2.python2.pkg }}

python2-dev:
  pkg.installed:
    - name: {{ python2.python2.dev_pkg }}

python2-pip:
  pkg.installed:
    - name: {{ python2.python2.pip_pkg }}
