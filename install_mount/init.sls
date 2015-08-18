{% set cluster =  salt['grains.get']('cluster')  %}
{% set mounts = salt['pillar.get']('install_mount:lookup') %}

#Mount the SFTP interface
{{ mounts.sftp_dir }} :
  mount.mounted:
    - device: {{ cluster }}-intf-01:{{ mounts.sftp_dir }} 
    - fstype: {{ mounts.fstype }}
    - mkmnt: True # Create mount points if not already present
    - persist: True
    - opts:       # A list object of options 
      - bg,hard,intr


{{ mounts.sftp_dir }}:
  mount.mounted:
    - device: {{ cluster }}-intf-01:{{ mounts.sftp_dir }}
    - fstype: {{ mounts.fstype }}
    - mkmnt: True
    - persist: True
    - opts:
      - bg,hard,intr
