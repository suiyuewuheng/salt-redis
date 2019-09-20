include: 
   - redis.install
   - redis.conf

{% set REDIS_HOME = '/usr/local/redis' %}
{% set PORT = '6379' %}
{% set VERSION = '5.0.5' %}

service_file:
  file.managed:
   - name: /etc/init.d/redis
   - source: salt://redis/files/redis_service
   - user: root
   - group: root
   - mode: 755
   - template: jinja
   - defaults:
     VERSION: {{VERSION}}
     REDIS_HOME: {{REDIS_HOME}}
     PORT: {{PORT}}

redis_chkconfig:
  cmd.run:
   - name: chkconfig --add redis && chkconfig --level 345 redis on
   - require:
     - file: service_file  

redis_service_start:
  service.running:
   - name: redis
   - enable: True
   - reload: True
   - require:
     - cmd: redis_chkconfig
