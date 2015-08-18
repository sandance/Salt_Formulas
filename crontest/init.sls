/home/nazmul/check.sh:
  cron.present:
    - user: root
    - hour: '*'
    - minute: 2
    - pkg: check.sh
