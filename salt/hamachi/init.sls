lsb-core:
  pkg.installed

Ensure lsb-core Dependencies Installed:
  cmd.wait:
    - name: apt-get install -f -y
    - watch:
      - pkg: lsb-core

Ensure Hamachi Installed:
  pkg.installed:
    - sources:
      - logmein-hamachi: https://secure.logmein.com/labs/logmein-hamachi_2.1.0.139-1_amd64.deb
    - require:
      - cmd: Ensure lsb-core Dependencies Installed

Ensure Hamachi Running:
  service.running:
    - name: logmein-hamachi
    - enable: True
    - require:
      - pkg: Ensure Hamachi Installed

Ensure Hamachi Login Command Runs:
  cmd.run:
    - name: hamachi logon
    - onlyif: hamachi logon
    - watch:
      - service: Ensure Hamachi Running

Ensure Server Attached to Hamachi:
  cmd.wait:
    - name: hamachi attach {{ pillar.get('hamachi_email') }}
    - unless: hamachi attach {{ pillar.get('hamachi_email') }} | grep -i pending
    - python_shell: True
    - watch:
      - cmd: Ensure Hamachi Login Command Runs
