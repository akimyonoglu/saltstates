newrelic-repo:
  pkgrepo.managed:
    - humanname: Newrelic PPA
    - name: deb http://apt.newrelic.com/debian newrelic non-free
    - file: /etc/apt/sources.list.d/newrelic.list
    - key_url: http://download.newrelic.com/548C16BF.gpg

newrelic-sysmond:
  pkg.installed:
    - require:
      - pkgrepo: newrelic-repo
  service.running:
    - enable: True
    - watch:
      - file: newrelic-sysmond
  file.managed:
    - name: /etc/newrelic/nrsysmond.cfg
    - source: salt://monitoring/newrelic/files/nrsysmond.cfg.jinja
    - makedirs: True
    - template: jinja
    - require:
      - pkg: newrelic-sysmond
