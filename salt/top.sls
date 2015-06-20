base:
  '*':
    - armagan
    - tools
    - hamachi
    - ssh.server
    - salt.minion

  'rainy* or dreamy*':
    - match: compound
    - openvpn.server
