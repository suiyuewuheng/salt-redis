include:
  - redis.install

{% set VERSION = '5.0.5' %}
{% set REDIS_HOME = '/usr/local/redis' %}
{% set PORTS = [6379] %}
{% for PORT in PORTS %}
redis_{{PORT}}_conf:
  file.managed:
    - name: {{REDIS_HOME}}/redis-{{PORT}}.conf
    - user: root
    - group: root
    - mode: 755
    - source: salt://redis/files/redis.conf
    - template: jinja
    - defaults:
      VERSION: {{VERSION}}
      PORT: {{PORT}}
      REDIS_HOME: {{REDIS_HOME}}

redis_exdir:
  file.directory:
    - names: 
      - {{REDIS_HOME}}/redis-{{VERSION}}/log
      - {{REDIS_HOME}}/redis-{{VERSION}}/data/{{PORT}}
      - {{REDIS_HOME}}/redis-{{VERSION}}/pid
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endfor %}
