sshd_config:
    Port: 22
    Protocol: 2
    HostKey:
      - /etc/ssh/ssh_host_rsa_key
    UsePrivilegeSeparation: 'yes'
    KeyRegenerationInterval: 3600
    ServerKeyBits: 768
    SyslogFacility: AUTH
              LogLevel: INFO
                LoginGraceTime: 120
                  PermitRootLogin: 'yes'
                    PasswordAuthentication: 'no'
                      StrictModes: 'yes'
                        RSAAuthentication: 'yes'
                          PubkeyAuthentication: 'yes'
                            IgnoreRhosts: 'yes'
                              RhostsRSAAuthentication: 'no'
                                HostbasedAuthentication: 'no'
                                  PermitEmptyPasswords: 'no'
                                    ChallengeResponseAuthentication: 'no'
                                      AuthenticationMethods 'publickey,keyboard-interactive'
                                        X11Forwarding: 'yes'
                                          X11DisplayOffset: 10
                                            PrintMotd: 'no'
                                              PrintLastLog: 'yes'
                                                TCPKeepAlive: 'yes'
                                                  AcceptEnv: "LANG LC_*"
                                                    Subsystem: "sftp /usr/lib/openssh/sftp-server"
                                                      UsePAM: 'yes'
                                                        UseDNS: 'yes'
                                                          AllowUsers: 'vader@10.0.0.1 maul@evil.com sidious luke'
                                                            DenyUsers: 'yoda chewbaca@112.10.21.1'
                                                              AllowGroups: 'wheel staff imperial'
                                                              DenyGroups: 'rebel'
                                                                  Deny
