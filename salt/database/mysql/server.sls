include:
  - database.mysql.common
  - database.mysql.client
  - database.mysql.databases

mysql_group:
  group.present:
    - name: mysql
    - system: True

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://database/mysql/my.cnf.jinja
    - template: jinja
    - require:
      - pkg: mysql-server

mysql_root:
  mysql_user.present:
    - name: root
    - password: {{ pillar.get('mysql_root_pass', "") }}
    - require:
      - service: mysql-server

mysql-server:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - name: mysql
    - require:
      - pkg: mysql-server
      - pkg: mysql-client
      - pkg: python-mysqldb
    - watch:
      - file: /etc/mysql/my.cnf