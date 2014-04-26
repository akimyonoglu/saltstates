include:
  - pound

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

{% set transmission = pillar.get("transmission", {}) %}

/etc/transmission-daemon/settings.json:
  file.managed:
    - source: salt://downloader/transmission/settings.json.jinja
    - template: jinja
    - require:
      - pkg: transmission-daemon
    - defaults:
        user: {{ transmission.get("user", "guest") }}
        pass: {{ transmission.get("pass", "guest") }}
        bind_to: {{ transmission.get("bind_iface", "127.0.0.1") }}
        port: {{ transmission.get("port", "9191") }}
        url: {{ transmission.get("url", "/piratebay/rpc") }}

/etc/pound/pound.cfg:
  file.managed:
    - source: salt://pound/pound.cfg.jinja
    - template: jinja
    - context:
        backend_addr: {{ transmission.get("bind_iface", "127.0.0.1") }}
        backend_port: {{ transmission.get("port", "9191") }}
        headers:
          - "Front-End-Https: on"
    - require:
      - pkg: pound
    - watch_in:
      - service: pound