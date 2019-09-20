include:
  - redis.install

{% set VERSION = '5.0.5' %}
{% set PORTS = [6379] %}
{% for PORT in PORTS %}
redis_{{PORT}}_conf:
  file.managed:
    - name: /usr/local/redis/redis_{{PORT}}.conf
    - user: root
    - group: root
    - mode: 755
    - source: salt://redis/files/redis.conf
    - template: jinja
    - defaults:
      VERSION: {{VERSION}}
      PORT: {{PORT}}
{% endfor %}
