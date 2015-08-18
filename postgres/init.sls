{% from "postgres/map.jinja" import postgres with context %}

install_postgres_lib:
  pkg.installed:
    - name : {{ postgres.pkg_lib }}
    #- sources:  http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/postgresql93-libs-9.3.6-1PGDG.rhel6.x86_64.rpm


install_postgresql:
    pkg.installed:
      - name: {{ postgres.pkg }}
      - fromrepo: rpm_repo
      - refresh: True

install_postgresql_server:
    pkg.installed:
      - name: {{ postgres.pkg_server }}
      - fromrepo: pgdg93
      - refresh: True

base:
    pkgrepo.managed:
        - humanname: PostgreSQL Official Repository
        - name: 'rpm_repo'
        - baseurl: http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm
        #- baseurl: http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/postgresql93-9.3.6-1PGDG.rhel6.x86_64.rpm

postgresql-initdb:
  cmd.run:
    - cwd: /
    - user: root
    - name: service postgresql-9.3 initdb



run-postgresql:
  service.running:
    - enable: True
    - name: {{ postgres.service }}
    - user: root
    - group: root
    - require: 
      - pkg: {{ postgres.pkg_server }}



#install-postgres-contrib:
  #  pkg.installed:
    # - name: {{ postgres.pkg_contrib }}
    #- fromrepo: pgdg93
    #- refresh: True

install-pgbouncer:
  pkg.installed:
    - name: 'pgbouncer'
    - fromrepo: pgdg93
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



