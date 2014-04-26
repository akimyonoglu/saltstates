pound:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: pound
      - file: /etc/default/pound

/etc/default/pound:
  file.replace:
    - pattern: startup=0
    - repl: startup=1
    - require:
      - pkg: pound
