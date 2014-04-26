include:
  - logging.logstash.common
  - golang

git:
  pkg.installed

/opt/logstash/forwarder:
  file.directory:
    - makedirs: True
    - user: logstash
    - require:
      - user: logstash

https://github.com/elasticsearch/logstash-forwarder.git:
  git.latest:
    - target: /opt/logstash/forwarder
    - user: logstash
    - require:
      - pkg: git
      - user: logstash
      - file: /opt/logstash/forwarder

/opt/logstash/forwarder/logstash-forwarder.init:
  file.sed:
    - before: /opt/logstash-forwarder
    - after: /opt/logstash/forwarder
    - flags: g
    - require:
      - git: https://github.com/elasticsearch/logstash-forwarder.git

/etc/init.d/logstash-forwarder:
  file.copy:
    - source: /opt/logstash/forwarder/logstash-forwarder.init
    - mode: '0755'
    - user: root
    - group: root
    - require:
      - file: /opt/logstash/forwarder/logstash-forwarder.init

make build-all:
  cmd.wait:
    - cwd: /opt/logstash/forwarder
    - env:
      - PATH: "$PATH:/usr/local/go/bin"
    - watch:
      - git: https://github.com/elasticsearch/logstash-forwarder.git
    - require:
      - cmd: untar_golang

logstash-forwarder:
  service.running:
    - enable: True
    - watch:
      - file: /etc/init.d/logstash-forwarder
      - git: https://github.com/elasticsearch/logstash-forwarder.git