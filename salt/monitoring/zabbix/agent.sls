include:
  - monitoring.zabbix.common

zabbix-agent:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/zabbix/zabbix_agentd.conf

/etc/zabbix/zabbix_agentd.conf:
  file.managed:
    - source: salt://monitoring/zabbix/files/zabbix_agentd.conf
    - template: jinja