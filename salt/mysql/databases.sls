include:
  - mysql.server

{% for dbname, config in pillar.get('mysql_databases', {}).items() %}

{% set dbuser = config.get('user', dbname) %}
{% set dbpass = config.get('pass', '') %}
{% set dbhost = config.get('host', 'localhost') %}

{{ dbname }}:
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
      - mysql_database: {{ dbname }}
      - mysql_user: {{ dbuser }}
      - pkg: python-mysqldb
      - pkg: mysql-server

{{ dbuser }}:
  mysql_user.present:
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