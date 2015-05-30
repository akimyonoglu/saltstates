armagan:
  user.present:
    - fullname: Armagan Kimyonoglu
    - shell: /bin/bash
    - home: /home/armagan
    - createhome: True
    - password: $6$vM7DTajG$GbktgtypZz37br6cHYeodWPf7M9E86.CjjMFfdaUHJ/UDruJj6apBTv3OmFIc.xaeLDLjRoJAhp8ZO2EsjLf3/
    - groups:
      - sudo

armagan_ssh_key:
  ssh_auth.present:
    - user: armagan
    - source: salt://armagan/id_rsa_personal.pub
    - require:
      - user: armagan

/etc/sudoers:
  file.append:
    - text: "armagan ALL=(ALL) NOPASSWD: ALL"
