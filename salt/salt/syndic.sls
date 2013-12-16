include:
  - salt.minion

install_syndic:
  cmd.wait:
    - name: sh salt_bootstrap.sh -S -N
    - cwd: /tmp
    - unless: which salt-syndic
    - watch:
      - cmd: install_minion

/etc/salt/master.d/syndic.conf:
  file.managed:
    - source: salt://salt/master.conf.jinja
    - template: jinja
    - context:
        syndic_master: {{ pillar.get("master_addr", "") }}
    - require:
      - service: salt-syndic

salt-syndic:
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/master.d/master.conf
    - require:
      - cmd: install_syndic