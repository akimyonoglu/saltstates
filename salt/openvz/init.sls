wheezy-openvz:
  pkgrepo.managed:
    - name: deb http://download.openvz.org/debian wheezy main
    - key_url: http://ftp.openvz.org/debian/archive.key
    - file: /etc/apt/sources.list.d/openvz.list

linux-image-openvz-amd64:
  pkg:
    - installed
    - refresh: True
    - require:
      - pkgrepo: wheezy-openvz

update-grub:
  cmd.wait:
    - watch:
      - pkg: linux-image-openvz-amd64

openvz-pkgs:
  pkg.installed:
    - refresh: True
    - pkgs:
      - vzctl
      - vzquota
      - ploop
      - vzstats
    - require:
      - pkgrepo: wheezy-openvz

/etc/default/grub:
  file.managed:
    - source: salt://openvz/grub.jinja
    - template: jinja
    - require:
      - cmd: update-grub

vz:
  service:
    - running
    - require:
      - pkg: openvz-pkgs

libvirt-bin:
  pkg.installed

{% set device = "" %}

{% if pillar.get("raid_disk", "") %}

{% set device = "/dev/"~pillar.get("raid_disk", "") %}

{% else %}
{% set unmounted_disks = pillar.get("lvm_disks", []) %}
{% set num_disks = unmounted_disks|length %}
{% if num_disks %}
{% for disk in unmounted_disks %}

/dev/{{ disk }}:
  lvm.pv_present:
    - require_in:
      - lvm: disks_vg
{% endfor %}

disks_vg:
  lvm.vg_present:
    {% for disk in unmounted_disks %}
    - devices: /dev/{{ disk }}
    {% endfor %}

{% set device = "/dev/disks_vg/logical_volume" %}
logical_volume:
  lvm.lv_present:
    - vgname: disks_vg
    - size: {{ 2.7 * num_disks }}T
    - require:
      - lvm: disks_vg

{% endif %}
{% endif %}

{% if device %}
mkfs.ext4 {{ device }}:
  cmd.run:
    - unless: "blkid {{ device }} || ps aux|grep 'mkfs.ext4' |grep -v grep"
    - require_in:
      - mount: /var/lib/vz

/var/lib/vz:
  mount.mounted:
    - device: {{ device }}
    - fstype: ext4
    - mkmnt: True
    - persist: True
    - opts:
      - defaults
    - require_in:
      - pkg: openvz-pkgs
{% endif %}
