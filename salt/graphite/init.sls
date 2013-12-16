include:
  - nginx
  - gunicorn
  - supervisor
  - python.common

/tmp/graphite-requirements.txt:
  file.managed:
    - source: salt://graphite/requirements.txt

graphite:
  pip.installed:
    - requirements: /tmp/graphite-requirements.txt
    - require:
      - pkg: common-python
      - file: /tmp/graphite-requirements.txt

/var/log/graphite:
  file.directory:
    - makedirs: True

/etc/supervisor/conf.d/graphite.conf:
  file.managed:
    - source: salt://supervisor/gunicorn-conf.jinja
    - template: jinja
    - context:
        autostart: true
        directory: /usr/local/bin
        priority: 1
        name: graphite
        directory: /opt/graphite/webapp/graphite
        stderr_logfile: /var/log/graphite/err.log
        stdout_logfile: /var/log/graphite/out.log
    - mode: 644
    - require:
      - pkg: supervisor
      - file: /var/log/graphite
    - watch_in:
      - cmd: supervisorctl update

/etc/nginx/sites-enabled/10-graphite.conf:
  file.managed:
    - source: salt://nginx/nginx.conf.jinja
    - template: jinja
    - context:
        app: graphite
        server_name: ~^graphite-?(?<ENV>.*)\.(?<DOMAIN>.*)\.com
        static_files: /opt/graphite/webapp/graphite
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx
      - file: /etc/supervisor/conf.d/graphite.conf

{% for file in ["dashboard.conf", "graphTemplates.conf", "carbon.conf"] %}
/opt/graphite/conf/{{ file }}:
  file.copy:
    - source: /opt/graphite/conf/{{ file }}.example
    - require:
      - pip: graphite
{% endfor %}

/opt/graphite/webapp/graphite/wsgi.py:
  file.copy:
    - source: /opt/graphite/conf/graphite.wsgi.example
    - require:
      - pip: graphite