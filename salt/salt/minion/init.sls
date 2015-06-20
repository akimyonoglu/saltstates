wget:
  pkg.installed

download_bootstrap:
  cmd.run:
    - name: "wget --no-check-certificate -O salt_bootstrap.sh http://bootstrap.saltstack.org && chmod +x salt_bootstrap.sh"
    - unless: ls salt_bootstrap.sh || which salt-minion
    - python_shell: True
    - cwd: /tmp
    - require:
      - pkg: wget

install_minion:
  cmd.wait:
    - name: sh salt_bootstrap.sh
    - cwd: /tmp
    - unless: which salt-minion
    - watch:
      - cmd: download_bootstrap

salt-minion:
  pkg.installed:
    - require:
      - cmd: install_minion
  service.running:
    - enable: True
    - require:
      - pkg: salt-minion

{% if grains.get('nodename') in ['rainy'] %}
/etc/salt/minion.d/beacons.conf:
  file.managed:
    - source: salt://salt/minion/files/beacons.conf
    - watch_in:
      - service: salt-minion
{% endif %}
