{% set domains = pillar.get('domains', '') %}
{% if domains and not salt['file.contains'](domains) %}
/etc/resolv.conf:
  file.append:
    - text: search {{ domains }}
{% endif %}
