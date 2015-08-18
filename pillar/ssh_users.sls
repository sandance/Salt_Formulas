ssh_users:
  lookup:
    lgf_deploy:
      - name: lgf_deploy
      - fullname: Logfire Deployment
      - state: present
      - shell: /bin/bash
      - groups: 
        - sudo
        #  - lgf_63_env
      - pub_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6zaaWO6M1+pkUx14hPpuCnfsOk/P21abPoZm5HG/QSdF+fNE3Ts9uyLn5ahiT8LeHuDNMuUs+ipYDnEspl0md9ZmyS64C3O6RwmS0EsGm1kkNRxXQMl/zcBXpAhOFnbu6aYQhnQivhObBugs1KRtxJJR0vxzJZqc0r8TN1lW0PmF9ABo1Td4kT0+Krn+dunUXYMWbiq/46AbJveUxjYdx6ELEaDzBLNnOie20MrHiHYj8dqwRxUOw61AknjFxZax72b5w8lFJbZicyUJ41IrbZluy4uSKsDYZxGSg0tQ1rNnaYcLDVPiMGPfwO+kp4cyDzKXs0DTvCq5Na9AeT7Xf  
      - uid: 8000
      #  ssh_groups:
        #lgf_env:
          # members:
            #gid: 8000
            #state: present
            #shell: /bin/bash

