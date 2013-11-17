transmission-cli:
  pkg.installed

transmission-daemon:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/transmission-daemon/settings.json

/etc/transmission-daemon/settings.json:
  file.managed:
    - source: salt://downloader/transmission/settings.json.jinja
    - template: jinja
    - require:
      - pkg: transmission-daemon
    - defaults:
      - username: armagan
      - password: {{ salt['shadow.info']('armagan')["passwd"] }}
      - bind_to: 25.117.225.62