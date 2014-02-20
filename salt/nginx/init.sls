nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/nginx/sites-enabled/default

/etc/nginx/sites-enabled/default:
  file.absent


/etc/nginx/sites-enabled/tevekkel:
  file.managed:
    - source:salt://nginx/sites/tevekkel