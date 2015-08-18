{% from "postgres/map.jinja" import postgres_pkg with context %}

install_postgres_rpm:
    pkg.installed:
        - name: {{ postgres.postgres_server }}
        - sources: {{ postgres.rpm }}


run-postgresql:
  service.running:
    - enable: True
    - name: {{ postgres.service }}
    - require: 
      - pkg: {{ postgres.pkg }}


install-postgres-contrib:
  pkg.installed:
    - name: {{ postgres.pkg_contrib }}

install-pgbouncer:
  pkg.installed:
    - name: pgbouncer
    - skip_verify: True
    - skip_suggestions: True
    - refresh: True # update the repo database of avialble packages prio to installing the requested package
    - require:
      - pkg: {{ postgres.pkg }}

{# creating postgres users #}
{% for name,user in postgres.users.items() %}
postgres-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
    - createdb: {{ user.get('createdb',False) }}
    - password: {{ user.get('password','changeme') }}
    - user: {{ user.get('runas','postgres') }}
    - require:
      - service: {{ postgres.service }}
{% endfor %}




{# Creating postgres tablespaces #}

{% for name, directory in postgres.tablespaces.items() %}
postgres-tablespace-dir-perm-{{ directory }}:
  file.directory:
    - name: {{ directory }}
    - user: postgres
    - group: postgres
    - makedirs: True
    - recurse:
      - user
      - group


postgres-tablespace-{{ name }}:
  postgres_tablespac.present:
    - name: {{ name }}
    - directory: {{ directory }}
    - require:
      - service: {{ postgres.service }}

{% endfor %}



