
/tmp/afpfs-ng-0.8.1.tar.bz2:
  file.managed:
    - source: http://sourceforge.net/projects/afpfs-ng/files/afpfs-ng/0.8.1/afpfs-ng-0.8.1.tar.bz2/download
    - source_hash: md5=1bdd9f8a06e6085ea4cc38ce010ef60b

build-pkgs:
  pkg.installed:
    pkgs:
      - build-essential
      - libgcrypt11
      - libgcrypt11-dev
      - libgmp3-dev
      - readline-common
      - libreadline6
      - libreadline6-dev
      - libfuse2
      - libfuse-dev

tar jxf afpfs-ng-0.8.1.tar.bz2:
  cmd.wait:
    - watch:
      - file: /tmp/afpfs-ng-0.8.1.tar.bz2
    - unless: ls /tmp/afpfs-ng-0.8.1

./configure:
  cmd.wait:
    - cwd: /tmp/afpfs-ng-0.8.1
    - watch:
      - cmd: tar jxf afpfs-ng-0.8.1.tar.bz2
    - unless: which mount_afp
    - require:
      - pkg: build-pkgs

make install:
  cmd.wait:
    - cwd: /tmpafpfs-ng-0.8.1
    - watch:
      - cmd: ./configure
    - unless: which mount_afp