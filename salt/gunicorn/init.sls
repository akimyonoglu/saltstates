include:
  - python.common
  - supervisor

gunicorn:
  pip.installed:
    - require:
      - pkg: common-python