zabbix_ppa:
  pkgrepo.managed:
    - humanname: Zabbix PPA
    - name: deb http://ppa.launchpad.net/tbfr/zabbix/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/zabbix.list
    - keyid: C407E17D5F76A32B
    - keyserver: keyserver.ubuntu.com