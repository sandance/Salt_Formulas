{% from "zabbix/map.jinja" import zabbix with context %}


zabbix-agent_repo:
  pkgrepo.managed:
    - humanname: Zabbix Official Repository - $basearch
    - name : zabbix
    - baseurl : {{ zabbix.agent.rpm_alter }} 
    - enabled: True
    - gpgcheck: 1
    - skip_verify : False
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
    - require:
      - file: zabbix-agent_repo_gpg_file

zabbix-agent_repo_gpg_file:
  file.managed:
        - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
        - source: http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
        - source_hash: 'md5=f6faf5b075d46f0d50053cf60f7b6f31' 


zabbix-agent_non_supported_repo:
  pkgrepo.managed:
    - name: zabbix_non_supported
    - humanname: Zabbix Official Repository non-supported - $basearch
    - baseurl: http://repo.zabbix.com/non-supported/rhel/6/$basearch/
    - gpgcheck: 1
    - skip_verigy : False



zabbix-agent:
  pkg.installed:
    - name: {{ zabbix.agent.pkg }}
    - version: {{ zabbix.agent.version }}
    - refresh: True
    - skip_suggestions: True



  service.running:
    - name: {{ zabbix.agent.service }}
    - enable: True
    - user: root
    - require:
      - pkg: zabbix-agent

/etc/zabbix/zabbix_agentd.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://zabbix/files/zabbix_agentd.conf.jinja
    - template: jinja
    - require:
      - pkg: zabbix-agent

#remove_repo:
  #  pkgrepo.absent:
  # - name : rpm_repo
  #  - baseurl : {{ zabbix.agent.rpm }}
