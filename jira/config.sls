# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "jira/map.jinja" import jira with context %}

{% if grains.init == "systemd" %}
# systemd init script
jira_init_script:
  file.managed:
    - name: '/lib/systemd/system/jira.service'
    - source: salt://jira/files/jira_systemd_script.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: jira_service

jira_remove_old_init_script:
  file.absent:
    - name: '/etc/init.d/jira'
{% else %}
# sysv init script
jira_init_script:
  file.managed:
    - name: '/etc/init.d/jira'
    - source: salt://jira/files/jira_init_script.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0755
{% endif %}

jira_ensure_conf_dir_perms:
  file.directory:
    - name: {{ jira.install_dir }}/conf
    - user: jira
    - group: root
    - mode: 0755
    - makdedirs: True
    
jira_server_config_file:
  file.managed:
    - name: {{ jira.install_dir }}/conf/server.xml
    - source: salt://jira/files/server.xml.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: jira_service

jira_env_vars:
  file.managed:
    - name: {{ jira.install_dir }}/bin/setenv.sh
    - source: salt://jira/files/setenv.sh.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: jira_service

jira_web_config:
  file.managed:
    - name: {{ jira.install_dir }}/atlassian-jira/WEB-INF/web.xml
    - source: salt://jira/files/web.xml.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: jira_service

{% if jira.tomcat.https %}
jira_https_keystore:
  file.managed:
    - name: {{ jira.install_dir }}/{{ jira.tomcat.keystore}}
    - source: salt://jira/files/{{ jira.tomcat.keystore }}
    - user: jira
    - group: root
    - mode: 0644
    - watch_in:
      - service: jira_service
{% endif %}

{% if jira.mysql.managed is defined and jira.mysql.managed %}
{% if jira.mysql.username is defined and jira.mysql.password is defined %}
jira_mysql_db:
  mysql_database.present:
    - name: {{ jira.mysql.dbname }}
    - unless: test -d /var/lib/mysql/{{ jira.mysql.dbname }}

jira_mysql_user:
  mysql_user.present:
    - name: {{ jira.mysql.username }}
    - host: {{ jira.mysql.hostname }}
    - password: {{ jira.mysql.password }}
    - onchanges:
      - mysql_database: jira_mysql_db
 
jira_mysql_grants:
  mysql_grants.present:
    - grant: SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX
    - database: {{ jira.mysql.dbname }}.*
    - user: {{ jira.mysql.username }}
    - host: {{ jira.mysql.hostname }}
    - onchanges:
      - mysql_database: jira_mysql_db
{% endif %}

jira_mysql_backupscript:
  file.managed:
    - name: /etc/cron.hourly/mysql-backup
    - source: salt://jira/files/mysql-backup.sh.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0750

jira_mysql_backup_rotate:
  file.managed:
    - name: /etc/logrotate.d/mysql-backup
    - source: salt://jira/files/mysql-backup.logrotate.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
{% endif %}
