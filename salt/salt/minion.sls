wget:
  pkg.installed

download_bootstrap:
  cmd.run:
    - name: "wget --no-check-certificate -O salt_bootstrap.sh http://bootstrap.saltstack.org && chmod +x salt_bootstrap.sh"
    - unless: ls salt_bootstrap.sh || which salt-minion
    - cwd: /tmp
    - require:
      - pkg: wget

install_minion:
  cmd.wait:
    - name: sh salt_bootstrap.sh
    - cwd: /tmp
    - unless: which salt-minion
    - watch:
      - cmd: download_bootstrap