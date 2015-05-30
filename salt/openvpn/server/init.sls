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
