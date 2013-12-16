# TODO add rabbit pkgrepo

deb http://www.rabbitmq.com/debian/ testing main:
  pkgrepo.managed:
    - key_url: http://www.rabbitmq.com/rabbitmq-signing-key-public.asc

rabbitmq-server:
  pkg:
    - installed
    - require:
      - pkgrepo: deb http://www.rabbitmq.com/debian/ testing main
  service:
    - running
    - enable: True
    - require:
      - pkg: rabbitmq-server
#    - watch:
#      - rabbitmq_plugin: rabbitmq_management
#
#rabbitmq_management:
#  rabbitmq_plugin.enabled:
#    - env: HOME=/var/lib/rabbitmq
#    - require:
#      - pkg: rabbitmq-server