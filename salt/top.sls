base:
  '*':
    - armagan
    - tools
    - hamachi

  'rainy* or dreamy*':
    - match: compound
    - openvpn.server
