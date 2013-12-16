supervisor:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: supervisor
      - file: /etc/supervisord.conf

/etc/supervisord.conf:
  file.symlink:
    - target: /etc/supervisor/supervisord.conf

supervisorctl update:
  cmd.wait:
    - require:
      - pkg: supervisor
      - service: supervisor