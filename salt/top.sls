base:
  '*':
    - armagan
    - tools
    - ssh.server
    - salt.minion
    - system
    - monitoring.newrelic

  'rainy* or dreamy*':
    - match: compound
    - pms
    - downloader.transmission
    - downloader.gdfuse
    - openvpn.server
