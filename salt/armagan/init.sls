armagan:
  user.present:
    - fullname: Armagan Kimyonoglu
    - shell: /bin/bash
    - home: /home/armagan
    - createhome: True
    - passwd: $6$8T2Jdc6h$o/77zpEb/NVEu3hb9RLgGyE7ycdz3S35lSjekKl6HHGp2H4AxIjKcGPN4pKAMgXCeXq4WFOTR8X713jTK7EAj1
    - groups:
      - sudo

armagan_ssh_key:
  ssh_auth:
    - present
    - user: armagan
    - source: salt://armagan/id_rsa_personal.pub
    - require:
      - user: armagan

/etc/sudoers:
  file.append:
    - text: "armagan ALL=(ALL) NOPASSWD: ALL"
