base:
  '*':
    - armagan
    - tools
  'rainy*':
    - downloader.transmission
    - monitoring.zabbix.server

  'jira*':
    - atlassian.jira