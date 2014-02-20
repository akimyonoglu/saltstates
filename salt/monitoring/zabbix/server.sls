include:
  - mysql.databases
  - nginx
  - php.cgi.fpm
  - monitoring.zabbix.agent

zabbix_pkgs:
  pkg.install:
    - pkgs:
      - zabbix-server-mysql
      - zabbix-frontend-php
    - refresh: True
    - require:
      - pkgrepo: zabbix_ppa

zabbix-server:
  service.running:
    - enable: True

{% set dbname = "zabbix" %}
{% set dbconf = pillar.get("mysql_databases", {}).get(dbname, {}) %}
{% set user = dbconf.get("user", "zabbix") %}
{% set pass = dbconf.get("pass", "zabbix") %}
{% set host = "localhost" %} #TODO make this generic

{% for file in ["zabbix_server.conf", "zabbix.conf.php"] %}

/etc/zabbix/{{ file }}:
  file.managed:
    - source: salt://monitoring/zabbix/files/{{ file }}.jinja
    - template: jinja
    - context:
        user: {{ user }}
        pass: {{ pass }}
        host: {{ host }}
        name: {{ name }}
    - watch:
      - service: zabbix-server
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
    - name: mysql -h {{ host }} -u {{ user }} -p {{ pass }} {{ name }} < {{ data }}.sql
    - cwd: /usr/share/zabbix-server-mysql
    - require:
      - mysql_grants: {{ name }}
      {% for req in requirements %}
      - cmd: {{ req }}
      {% endfor %}
    - watch:
      - cmd: gunzip *.gz
    {% if loop.last %}
    - watch_in:
      - service: zabbix-server
    {% endif %}
{% do requirements.append("insert_"~data) %}
{% endfor %}

/etc/nginx/sites-available/zabbix.conf:
  file.managed:
    - source: salt://nginx/fastcgi.conf.jinja
    - template: jinja
    - defaults:
        app_name: {{ name }}
    - watch_in:
      - service: nginx

/etc/php5/fpm/conf.d/zabbix.conf:
  file.managed:
    - source: salt://php/cgi/fpm/php-conf.jinja
    - template: jinja
    - watch_in:
      - service: php5-fpm