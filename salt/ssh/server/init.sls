openssh-server:
  pkg.installed

ssh:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.append:
    - text: UseDNS no
    - require:
      - pkg: openssh-server
