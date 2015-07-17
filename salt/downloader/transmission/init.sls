Ensure Transmission Installed:
  pkg.installed:
    - names:
      - transmission-daemon
      - transmission-cli

Ensure Transmission Running:
  service.running:
    - name: transmission-daemon
    - enable: True
    - require: Ensure Transmission Installed
    - watch:
      - file: Ensure Transmission Configured

Ensure Incomplete Directory Present:
  file.directory:
    - name: /transmission/incomplete
    - makedirs: True
    - user: debian-transmission
    - group: debian-transmission
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require:
      - pkg: Ensure Transmission Installed

{% set transmission = pillar.get("transmission", {}) %}

Ensure Transmission Stopped:
  service.dead:
    - name: transmission-daemon

Ensure Transmission Configured:
  file.managed:
    - name: /etc/transmission-daemon/settings.json
    - source: salt://downloader/transmission/settings.json.jinja
    - template: jinja
    - require:
      - pkg: transmission-daemon
      - service: Ensure Transmission Stopped
      - file: Ensure Incomplete Directory Present
