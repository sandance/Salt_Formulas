postgres:
  pg_hba.conf:  salt://postgres/pg_hba.conf

  use_upstream_repo: False

  lookup:
    pkg:  'postgresq-9.3'
    pkg_client: 'postgresql-client-9.3'
    pg_hba: '/etc/postgresql/9.3/main/pg_hba.conf'


  users:
    localuser:
      password: '98ruj923h4rf'
      createdb: False
    
    remoteuser:
      password: '98ruj923h4rf'
      createdb: False


  acls:
        - ['local', 'db1', 'localUser']
        - ['host', 'db2', 'remoteUser', '123.123.0.0/24']

  databases:
    db1:
      owner:  'localuser'
      user: 'localuser'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

    db2:
      owner: 'localUser'
      user: 'remoteUser'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

postgreconf: | 
  listen_address = 'localhost,*'
