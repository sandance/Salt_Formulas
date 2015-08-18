apache:
  server: apache2
  service: apache2

  vhostdir: /etc/apache2/sites-available
  confdir: /etc/apache2/conf.d
  confest: .conf
  logdir: /var/log/apache2/
  wwwdir: /srv/apache2

  
  #apache.vhosts formula additional configuration
  sites:
    example.net:
      template_file: salt://apache/vhosts/minimal.tmpl
    example.com:
      template_file: salt://apache/vhosts/standard.tmpl

      #################### DEFAULT VALUES BELOW ################
      template_engine: jinja
      interface: '*'
      port: '80'

      ServerName: example.com
      ServerAlias: www.example.com

      ServerAdmin: webmaster@example.com

      LogLevel: warn
      ErrorLog: /path/to/logs/example.com-error.log # /var/log/apache2/example.com-error.log
      CustomLog: /path/to/logs/example.com-access.log #  /var/log/apache2/example.com-error.log
      DocumentRoot: /path/to/www/dir/example.com # /var/log/example.com

      Directory:
        default:
          Options: -Indexes FollowSymLinks
          Order: allow, deny
          Allow: from all
          Require: all granted
          AllowOverride: None
          Formula_Append: |

      register-site:


      modules:
        enabled:
          - ldap
          - ssl
        disabled:
          - rewrite
