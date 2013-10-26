#!jinja|yaml

include:
  dirty-users

{% if grains['id'] == pillar.get('nfs',{}).get('master') %}
/etc/exports.d:
  file.directory:
    - user: root
    - group: root
    - mode: 0731

/etc/exports.d/salt.dirty-users.exports:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - contents: {{ pillar['dirty-users']['homesdir'] }} {% for client in pillar['dirty-users']['clients'] %} {{ client }}(rw) {% endfor %}
    - require:
        - file.directory: /etc/exports.d
        - pkg: nfs-kernel-server
{% else %}
/etc/passwd:
  file.managed:
    source: salt://dirty-users/passwd

/etc/group:
  file.managed:
    source: salt://dirty-users/group

{{ pillar['dirty-users']['homesdir'] }}:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
  mount.mounted:
    - device: {{ pillar['dirty-users']['master_uri'] }}:{{ pillar['dirty-users']['homesdir'] }}
    - fstype: nfs
    - opts: rw,bg
    - require:
      - file: {{ pillar['dirty-users']['homesdir'] }}
      - pkg: nfs-common


{% endif %}
