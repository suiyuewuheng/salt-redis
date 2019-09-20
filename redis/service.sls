include: 
   - redis.install
   - redis.conf

service_file:
  file.managed:
   - name: /etc/init.d/redis
   - source: salt://redis/files/redis_service
   - user: root
   - group: root
   - mode: 755
   - unless:
     - test -e /etc/init.d/redis

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
   - watch:
     - file: service_file
