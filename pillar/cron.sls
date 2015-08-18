cron:
  lookup:
    jobs:
      disk_check:
        user: root
        cmd: df -h
        minute: 1
        hour: 2
        daymonth:
        identifier: SUPERCRON
