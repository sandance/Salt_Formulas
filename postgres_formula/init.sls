{% from "postgres/map.jinja" import postgres with context %}

{% if postgres.use_upstream_repo %}
include:
    - postgres.upstream
{% endif %}

install-postgresql:
  pkg.installed:
    - name: {{ postgres.pkg }}
    - refresh: {{ postgres.use_upstream_repo }}


{% if postgres.create_cluster != False %}
create-postgresql-cluster:
  cmd.run:
    - cwd: /
    - user: root
    - name: pg_createcluster {{ postgres.version }} main --start
    - unless: test -f {{ postgres.conf_dir }}/postgresql.conf
    - env:
      LC_ALL: C.UTF-8
{% endif %}

{% if postgres.init_db != False %}
postgresql-initdb:
    cmd.run:
    - cwd: /
    - user: root
    - name: service postgresql initdb
    - unless: test -f {{ postgres.conf_dir }}/postgresql.conf
    - env:
          LC_ALL: C.UTF-8
{% endif %}

run-postgresql:
  service.running:
    - enable: true
    - name: {{ postgres.service }}
    - require:
      - pkg: {{ postgres.pkg }}


{% if postgres.pkg_contrib != False %}
install-postgres-contrib:
    pkg.installed:
      - name: {{ postgres.pkg_contrib }}
{% endif %}

{% if postgres.postgresconf %}
postgresql-conf:
    file.blockreplace:
      - name: {{ postgres.conf_dir }}/postgresql.conf
      - marker_start: "# Managed by SaltStack: listen_addresses: please do not edit"
      - marker_end: "# Managed by SaltStack: end of salt managed zone --"
      - content: | {{ postgres.postgresconf|indent(8) }}
      - show_changes: True
      - append_if_not_found: True
      - watch_in:
        - service: postgresql
{% endif %}
