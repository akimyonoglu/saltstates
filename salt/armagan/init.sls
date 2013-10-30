armagan:
  user.present:
    - fullname: Armagan Kimyonoglu
    - shell: /bin/bash
    - home: /home/armagan
    - createhome: True
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
