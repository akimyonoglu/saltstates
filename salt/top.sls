base:
  '*':
    - armagan
    - tools

  'rainy*':
    - downloader.transmission
    - monitoring.zabbix.server
    - monitoring.zabbix.agent

  'jira*':
    - atlassian.jira