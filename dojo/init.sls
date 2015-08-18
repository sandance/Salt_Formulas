{% from "dojo/map.jinja" import dojo with context %}

{{ dojo.lgfwms_install_dir }}:
  file.directory:
    - user: {{ dojo.user }}
    - group: {{ dojo.group }}
    - dir_mode: {{ dojo.dir_mode }}
    - file_mode: {{ dojo.file_mode }}
    - makedirs: True
    - recurse:
      - user
      - group
      - dir_mode

{{ dojo.lgfwms_install_dir }}/{{ dojo.dojo_released_version }}.zip:
  file.managed:
    - source: salt://templates/global/dojo/{{ dojo.dojo_released_version }}.zip
    - user: {{ dojo.user }}
    - group: {{ dojo.group }}
    - mode: 0644

unpack dojo-installer:
  module.run:
    - name: archive.unzip
    - zipfile: {{ dojo.lgfwms_install_dir }}/{{ dojo.dojo_released_version }}.zip
    - dest: {{ dojo.dest_dir }}

/usr/lgfwms/dojo:
  file.symlink:
    - target: {{ dojo.lgfwms_install_dir }}/{{ dojo.dojo_released_version }}
