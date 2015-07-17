Ensure Plex Media Server Installed:
  pkg.installed:
    - sources:
      - plexmediaserver: https://downloads.plex.tv/plex-media-server/0.9.12.4.1192-9a47d21/plexmediaserver_0.9.12.4.1192-9a47d21_amd64.deb

Ensure Plex Media Server Running:
  service.running:
    - name: plexmediaserver
    - enabled: True
    - require:
      - pkg: Ensure Plex Media Server Installed
