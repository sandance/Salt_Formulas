{% from "postgres/map.jinja" import postgres with context %}

{% if postgres.use_upstream_repo %}
include:
  - postgres.upstream
{% endif %}

install-postgresql-client:
  pkg.installed:
    - name: {{ postgres.pkg_client }}
    - refresh: {{ postgresql.use_upstream_repo }}

{% if postgres.pkg_libpq_dev != False %}
instll-postgres-libpq-dev:
  pkg.installed:
    - name: {{ postgres.pkg_libpq_dev }}
{% endif %}
