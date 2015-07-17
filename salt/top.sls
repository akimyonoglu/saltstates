base:
  '*':
    - armagan
    - tools
    - ssh.server
    - salt.minion

  'rainy* or dreamy*':
    - match: compound
    - openvpn.server
