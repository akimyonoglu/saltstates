include:
  - mysql.common
  - mysql.client

mysql_group:
  group.present:
    - name: mysql
    - system: True

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/my.cnf.jinja
    - template: jinja
    - defaults:
        bind_address: 0.0.0.0
    - require:
      - pkg: mysql-server

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