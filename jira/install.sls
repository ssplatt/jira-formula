# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "jira/map.jinja" import jira with context %}

jira_install_requirements:
  pkg.installed:
    - pkgs: {{ jira.required_pkgs }}

{% if jira.java.managed %}
{% if jira.java.fromrepo == "jessie-backports" %}
jira_jessie_backports_repo_managed:
  pkgrepo.managed:
    - humanname: Jessie Backports
    - name: deb http://ftp.debian.org/debian jessie-backports main
    - file: /etc/apt/sources.list.d/jessie-backports.list
{% endif %}

jira_install_java_jre:
  pkg.installed:
    - name: {{ jira.java.pkg }}
    {% if jira.java.fromrepo is defined -%}
    - fromrepo: {{ jira.java.fromrepo }}
    {% endif %}
{% endif %}

{% if jira.tomcat.proxy %}
jira_install_nginx:
  pkg.installed:
    - name: nginx
{% endif %}

jira_latest_bin:
  file.managed:
    - name: /root/{{ jira.latest.filename }}
    - source: {{ jira.latest.url }}
    - source_hash: {{ jira.latest.hash }}
    - user: root
    - group: root
    - mode: 0755

jira_response_file:
  file.managed:
    - name: '/root/response.varfile'
    - source: salt://jira/files/response.varfile.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

jira_install_script:
  cmd.run:
    - name: /root/{{ jira.latest.filename }} -q -varfile /root/response.varfile
    - unless: test -d {{ jira.install_dir }}

{% if jira.mysql.managed is defined and jira.mysql.managed %}
jria_mysql_connector:
  archive.extracted:
    - name: /root
    - source: {{ jira.mysql.connector_url }}
    - source_hash: {{ jira.mysql.connector_hash }}
    - tar_options: ''
    - archive_format: tar
    - if_missing: /root/{{ jira.mysql.connector_dir }}

jira_copy_mysql_connector:
  file.copy:
    - name: /opt/atlassian/jira/lib/{{ jira.mysql.connector_jar }}
    - source: /root/{{ jira.mysql.connector_dir }}/{{ jira.mysql.connector_jar }}
{% endif %}
