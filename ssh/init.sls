{% import_yaml "ssh/defaults.yaml" as defaults %}
{% set groups = defaults.ssh_user.groups %}

ssh_user:
  user.present:
    - name: {{ defaults.ssh_user.name }}
    - fullname: {{ defaults.ssh_user.fullname }}
    - home: /home/{{ defaults.ssh_user.name }}
    - shell: /bin/bash
    - uid: {{ defaults.ssh_user.uid }}
    
lgf_deploy:
  group.present:
    - name: {{ defaults.ssh_user.name }}
    - system: True
    - addusers:
      - {{ defaults.ssh_user.name }}
    - gid: {{ defaults.ssh_user.gid }}
    - require:
      - user: {{ defaults.ssh_user.name }}


sshkeys:
  ssh_auth.present:
    - user: {{ defaults.ssh_user.name }}
    - name: {{ defaults.ssh_user.name }}
    - source: salt://ssh/files/id_rsa.pub 


/etc/sudoers:
  file.append:
    - text:
      - "# Adding lgf_deploy for lgf_env"
      - "lgf_deploy   ALL=(lgf_64_env)  NOPASSWD:ALL"

#add pg password file 
/home/{{ defaults.ssh_user.name }}/.pgpass:
  file.managed:
    - source: salt://ssh/files/.pgpass
    - user: {{ defaults.ssh_user.name }}
    - group: {{ defaults.ssh_user.name }}
    - mode: 600
    - require:
        - user: {{ defaults.ssh_user.name }}


# change directoy permissions
/usr/lgfwms/lgf_64_env:
  file.directory:
    - user: lgf_64_env
    - group: lgf_64_env
    - mode: 755
    - recurse:
      - user
      - group
      - mode
    
