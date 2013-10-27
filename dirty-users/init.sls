nfs-common:
  pkg.installed

{% if grains['id'] == pillar['dirty-users']['master'] %}
nfs-kernel-server:
  pkg:
    - installed
  service:
    - running
    - enable: True

{% endif %}
