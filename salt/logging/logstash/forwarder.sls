https://github.com/elasticsearch/logstash-forwarder.git:
  git.latest:
    - target: /opt/logstash-forwarder
    - require:
      - pkg: git

