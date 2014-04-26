include:
  - web.apache2

git:
  pkg.installed

libapache2-mod-passenger:
  pkg.installed
    - require:
      - pkg: apache2

ruby:
  pkg.installed

ruby-dev:
  pkg.installed

rubygems:
  pkg.installed

ruby-bundler:
  pkg.installed

https://github.com/rashidkpc/Kibana.git:
  git.latest:
    - target: /var/www/kibana
    - require:
      - pkg: git

/etc/apache2/sites-available/logstash:
  file.managed:
    - source: salt://web/apache2/files/logstash-apache2.conf
    - template: jinja
    - watch_in:
      - service: apache2

/usr/sbin/a2ensite logstash:
  cmd.wait:
    - unless: ls -l /etc/apache2/sites-enabled | grep logstash
    - require:
      - pkg: libapache2-mod-passenger
    - watch:
      - file: /etc/apache2/sites-available/logstash

bundle install:
  cmd.wait:
    - unless: gem list | grep sinatra
    - cwd: /var/www/kibana
    - require:
      - pkg: rubygems
      - pkg: ruby-bundler
    - watch:
      - git: https://github.com/rashidkpc/Kibana.git
    - watch_in:
      - service: apache2
