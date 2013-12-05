include:
  - java.openjdk.jre

{% set jira_version = pillar.get("jira_version", "6.1.3") %}

/tmp/atlassian-jira-{{ jira_version }}.tar.gz:
  file.managed:
    - source: http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.1.3.tar.gz
    - source_hash: md5=acb44c0a15b5cc191a10853a191a45aa

/usr/local/jira:
  file.directory:
    - makedirs: True

/var/jira-home:
  file.directory:
    - makedirs: True

set-jira-home:
  file.managed:
    - name: /usr/local/jira/atlassian-jira/WEB-INF/classes/jira-application.properties
    - contents: "jira.home = /var/jira-home"
    - require:
      - file: extract_files

extract_files:
  cmd.wait:
    - name: tar -xzf /tmp/atlassian-jira-{{ jira_version }}.tar.gz -C /usr/local/jira --strip-components=1
    - unless: /usr/local/jira/README.html
    - watch:
      - file: /tmp/atlassian-jira-{{ jira_version }}.tar.gz
    - require:
      - file: /usr/local/jira
      - file: /var/jira-home