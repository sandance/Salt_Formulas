nginx:
  lookup:
  config:
    - server:
      - server_name: _
      - listen:
        - 443
      - ssl:
        - on
      - ssl_certificate:
        - /etc/nginx/certs/logfireapps.com.crt
      - ssl_certificate_key:
        - /etc/nginx/certs/logfireapps.com.key
      - ssl_session_timeout:
        - 5m
      - client_max_body_size:
        - 20m
      - ssl_protocols:
        - SSLv2
        - SSLv3
        - TLSv1
      - ssl_ciphers:
        - 
      - ssl_prefer_server_ciphers:
        - on
      - proxy_read_timeout:
        - 6000
      - location ~ ^/[a-zA-Z0-9]+_63_+[a-zA-Z0-9]+_rf+:
        - proxy_pass:
          - $uri

