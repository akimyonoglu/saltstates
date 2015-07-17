base:
  '*':
    - armagan
    - tools
    - ssh.server
    - salt.minion

  'rainy* or dreamy*':
    - match: compound
    - pms
    - downloader.transmission
    - downloader.gdfuse
    - openvpn.server
