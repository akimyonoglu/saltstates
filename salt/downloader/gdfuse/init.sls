python-software-properties:
  pkg.installed

Ensure Google Drive Fuse Repo Present:
  pkgrepo.managed:
    - ppa: ppa:alessandro-strada/ppa
    - require:
      - pkg: python-software-properties

Ensure Google Drive Fuse Package Installed:
  pkg.latest:
    - name: google-drive-ocamlfuse
    - refresh: True
    - require:
      - pkgrepo: Ensure Google Drive Fuse Repo Present

Ensure Data Directory Present:
  file.directory:
    - name: /srv
    - makedirs: True
