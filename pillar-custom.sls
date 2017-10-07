# -*- coding: utf-8 -*-
# vim: ft=yaml
---
jira:
  enabled: true
  hostname: server
  jvm_min_mem: 512m
  jvm_max_mem: 1024m
  jvm_support_recommended_args: "-Dhttp.proxyHost=proxy.example.org -Dhttp.proxyPort=8080 -Dhttps.proxyHost=proxy.example.org -Dhttps.proxyPort=8080 -Dhttp.nonProxyHosts=localhost"
  service:
    enable: True
    state: running
  required_pkgs:
    - 'mariadb-client'
    - 'mariadb-server'
    - 'python-mysqldb'
  mysql:
    managed: true
  web:
    sessiontimeout: 600
  java:
    managed: true
