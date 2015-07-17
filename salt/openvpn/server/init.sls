include:
  - armagan

Ensure Openvpn Installed:
  pkg.installed:
    - sources:
      - openvpn-as: http://swupdate.openvpn.org/as/openvpn-as-2.0.17-Ubuntu14.amd_64.deb

Ensure Openvpn Running:
  service.running:
    - name: openvpnas
    - enable: True
    - require:
      - pkg: Ensure Openvpn Installed

Promote Admin Privileges:
  cmd.wait:
    - name: ./sacli --user armagan --key prop_superuser --value true UserPropPut
    - unless: ./confdba -us | grep -A1 armagan |grep prop_superuser|grep true
    - cwd: /usr/local/openvpn_as/scripts
    - python_shell: True
    - watch:
      - service: Ensure Openvpn Running
    - require:
      - user: armagan
