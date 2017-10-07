# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "jira/map.jinja" import jira with context %}

jira_service:
  service.{{ jira.service.state }}:
    - name: {{ jira.service.name }}
    - enable: {{ jira.service.enable }}
