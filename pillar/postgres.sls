postgres:
    lookup:
        pkg: 'postgresql-9.3'
        version: '9.3.6'
        pkg_client: 'postgresql-client-9.3'
        rpm: 
    users:
        localUser:
            password: 'changeme'
            createdb: False
        
        remoteUser:
            password: 'changeme'
            createdb: False

