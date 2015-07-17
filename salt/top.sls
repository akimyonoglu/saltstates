base:
  '*':
    - armagan
    - tools
    - ssh.server
    - salt.minion
    - system

  'rainy* or dreamy*':
    - match: compound
    - pms
    - downloader.transmission
    - downloader.gdfuse
    - openvpn.server
