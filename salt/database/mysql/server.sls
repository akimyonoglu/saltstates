include:
  - database.mysql.common
  - database.mysql.client

mysql_group:
  group.present:
    - name: mysql
    - system: True

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/my.cnf.jinja
    - template: jinja
    - require:
      - pkg: mysql-server

mysql_user.present:
  - name: root
  - password: {{ pillar.get('mysql_root_pass', "") }}
  - require:
    - service: mysqld

mysql-server:
  pkg.installed:
    - name: "mysql-server"
  service.running:
    - name: mysql
    - require:
      - pkg: mysql-server
      - pkg: mysql-client
      - pkg: python-mysqldb
    - watch:
      - file: /etc/mysql/my.cnf