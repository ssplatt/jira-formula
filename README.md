jira-formula
=============

installs and configures a jira server. Jira uses an internal Tomcat server, so there are some files and settings for running HTTPS or non https. Tomcat can also be configured to run behind a proxy (i.e. nginx).

Defaults:
```
jira:
  enabled: False
  hostname: localhost
  install_dir: /opt/atlassian/jira
  jvm_min_mem: 384m
  jvm_max_mem: 768m
  jvm_support_recommended_args: ""
  required_pkgs: []
  tomcat:
    https: False
    proxy: False
    http_port: 8080
    https_port: 8443
    keystore: jira.keystore
    keypass: changeit
  latest:
    filename: 'atlassian-jira-software-7.4.2-x64.bin'
    url: 'https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-7.4.2-x64.bin'
    hash: md5=626db673a41b39c7ca1fbeb53a3b8ec4
  mysql:
    managed: false
    username: 'jira'
    hostname: 'localhost'
    password: 'jira'
    dbname: 'jira'
    connector_url: http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.43.tar.gz
    connector_dir: mysql-connector-java-5.1.43
    connector_hash: md5=695d1a0745ef38fa82cd3059b1db4497
    connector_jar: mysql-connector-java-5.1.43-bin.jar
  web:
    sessiontimeout: 300
  service:
    name: jira
    enable: False
    state: dead
```

Typical Config:
```
jira:
  enabled: true
  hostname: server
  jvm_min_mem: 1024m
  jvm_max_mem: 4096m
  jvm_support_recommended_args: -Dhttp.proxyHost=proxy.example.org -Dhttp.proxyPort=8080 -Dhttps.proxyHost=proxy.example.org -Dhttps.proxyPort=8080 -Dhttp.nonProxyHosts=localhost|*.atlassian.com
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
```
