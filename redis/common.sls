{%from"redis/map.jinja"importredis_settingswithcontext%}


{%setinstall_from=redis_settings.install_from-%}


{%ifinstall_from=='source'%}
{%setversion=redis_settings.version|default('2.8.8')-%}
{%setchecksum=redis_settings.checksum|default('sha1=aa811f399db58c92c8ec5e48271d307e9ab8eb81')-%}
{%setroot=redis_settings.root|default('/usr/local')-%}

{#thereisamissingconfigtemplateforversion2.8.8#}

redis-dependencies:
  pkg.installed:
  -names:
  {%ifgrains['os_family']=='RedHat'%}
    -python-devel
    -make
    -libxml2-devel
  {%elifgrains['os_family']=='Debian'or'Ubuntu'%}
    -build-essential
    -python-dev
    -libxml2-dev
{%endif%}


get-redis:
  file.managed:
  -name:{{root}}/redis-{{version}}.tar.gz
  -source:http://download.redis.io/releases/redis-{{version}}.tar.gz
  -source_hash:{{checksum}}
  -require:
  -pkg:redis-dependencies
  cmd.wait:
  -cwd:{{root}}
  -names:
  -tar-zxvf{{root}}/redis-{{version}}.tar.gz-C{{root}}
  -watch:
  -file:get-redis


make-and-install-redis:
  cmd.wait:
  -cwd:{{root}}/redis-{{version}}
  -names:
  -make
  -makeinstall
  -watch:
  -cmd:get-redis


{%elifinstall_from=='package'%}


install-redis:
pkg.installed:
-name:{{redis_settings.pkg_name}}
{%ifredis_settings.versionisdefined%}
-version:{{redis_settings.version}}
{%endif%}


{%endif%}
