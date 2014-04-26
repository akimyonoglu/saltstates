include:
  - java.openjdk.jre
  - logging.logstash.common

/opt/logstash/:
  file.directory:
    - makedirs: True
    - user: logstash
    - group: logstash
    - require:
      - user: logstash

/opt/logstash/log/:
  file.directory:
    - makedirs: True
    - user: logstash
    - group: logstash
    - require:
      - user: logstash

/etc/logstash/:
  file.directory:
    - makedirs: True
    - user: root
    - group: root

/etc/logstash/logstash.conf:
  file.managed:
    - source: salt://logging/logstash/files/logstash.conf
    - template: jinja

/etc/init/logstash.conf:
  file.managed:
    - source: salt://logging/logstash/files/logstash.init

logstash:
  file.managed:
    - source: https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar
    - source_hash: md5=6ef146931eb8d4ad3f1b243922626923
    - name: /usr/share/logstash/logstash-latest-monolithic.jar
    - user: root
    - group: root
    - mode: 664
    - require:
      - pkg: openjdk-jre
  service.running:
    - enable: True
    - watch:
      - file: /etc/init/logstash.conf
      - file: /etc/logstash/logstash.conf
    - require:
      - user: logstash