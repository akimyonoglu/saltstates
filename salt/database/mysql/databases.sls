include:
  - database.mysql.server

{% for dbname, config in pillar.get('mysql_databases', {}).items() %}

{% set dbuser = config.get('user', dbname) %}
{% set dbpass = config.get('pass', '') %}
{% set dbhost = config.get('host', 'localhost') %}

{{ dbname }}_db:
  mysql_database.present:
    - connection_user: root
    - connection_pass: {{ pillar.get("mysql_root_pass", "") }}
  mysql_grants.present:
    - grant: select,insert,update,create,delete
    - database: {{ dbname }}.*
    - user: {{ dbuser }}
    - host: {{ dbhost }}
    - connection_user: root
    - connection_pass: {{ pillar.get("mysql_root_pass", "") }}
    - require:
      - mysql_database: {{ dbname }}_db
      - mysql_user: {{ dbuser }}_dbuser
      - pkg: python-mysqldb
      - pkg: mysql-server

{{ dbuser }}_dbuser:
  mysql_user.present:
    - name: {{ dbuser }}
    - host: localhost
    - password: {{ dbpass }}
    - connection_user: root
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - connection_pass: {{ pillar.get("mysql_root_pass", "") }}
    - connection_charset: utf8
    - require:
      - pkg: python-mysqldb
      - pkg: mysql-server
{% endfor %}