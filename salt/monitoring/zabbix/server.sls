include:
  - mysql.databases
  - nginx
  - php.cgi.fpm
  - monitoring.zabbix.common

zabbix_pkgs:
  pkg.install:
    - pkgs:
      - zabbix-server-mysql
      - zabbix-frontend-php
    - refresh: True
    - require:
      - pkgrepo: zabbix_ppa

{% for file in ["zabbix_server.conf", "zabbix.conf.php"] %}

/etc/zabbix/{{ file }}:
  file.managed:
    - source: salt://monitoring/zabbix/files/{{ file }}.jinja
    - defaults:
        dbconf: {{ pillar.get("mysql_databases", {}).get("zabbix", {}) }}
    - template: jinja
{% endfor %}

gunzip *.gz:
  cmd.wait:
    - cwd: /usr/share/zabbix-server-mysql
    - watch:
      - pkg: zabbix_pkgs

{% set requirements = [] %}
{% for data in ["schema", "images", "data"] %}
insert_{{ data }}:
  cmd.wait:
    - name: mysql -u zabbix -p zabbix < {{ data }}.sql
    - require:
      - mysql_grants: zabbix
      {% for req in requirements %}
      - cmd: {{ req }}
      {% endfor %}
    - watch:
      - cmd: gunzip *.gz
{% do requirements.append("insert_"~data) %}
{% endfor %}

/etc/nginx/sites-available/zabbix.conf:
  file.managed:
    - source: salt://nginx/fastcgi.conf.jinja
    - template: jinja
    - defaults:
        app_name: zabbix
    - watch_in:
      - service: nginx

/etc/php5/fpm/conf.d/zabbix.conf:
  file.managed:
    - source: salt://php/cgi/fpm/php-conf.jinja
    - template: jinja
    - watch_in:
      - service: php5-fpm