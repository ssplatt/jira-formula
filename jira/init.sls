# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "jira/map.jinja" import jira with context %}

{% if jira.enabled %}
include:
  - jira.install
  - jira.config
  - jira.service
{% else %}
'jira-formula disabled':
  test.succeed_without_changes
{% endif %}
