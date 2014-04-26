logstash:
  user.present:
    - fullname: Logstash User
    - home: /opt/logstash
    - system: true

/etc/pki/tls/certs/logstash-forwarder.crt:
  file.managed:
    - source: salt://logging/logstash/files/logstash-forwarder.crt
    - user: logstash
    - mode: '0644'

/etc/pki/tls/private/logstash-forwarder.key:
  file.managed:
    - source: salt://logging/logstash/files/logstash-forwarder.key
    - user: logstash
    - mode: '0600'