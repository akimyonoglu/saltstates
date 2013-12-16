include:
  - salt.minion

install_master:
  cmd.wait:
    - name: sh salt_bootstrap.sh -M -N
    - cwd: /tmp
    - unless: which salt-master
    - watch:
      - cmd: install_minion

/etc/salt/master.d/master.conf:
  file.managed:
    - source: salt://salt/master.conf
    - context:
        master: {{ pillar.get("master_addr", "") }}
    - require:
      - cmd: install_master

salt-master:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/salt/master.d/master.conf
    - require:
      - cmd: install_master
