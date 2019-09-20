{% set VERSION = '5.0.5' %}
{% set REDIS_HOME = '/usr/local/redis' %}

redis_dir:
  file.directory:
    - name: {{REDIS_HOME}}
    - user: root
    - group: root
    - makedirs: True
    - unless:
      - test -d {{REDIS_HOME}}

redis_source:
  file.managed:
   - name: {{REDIS_HOME}}/redis-{{VERSION}}.tar.gz
   - source: salt://redis/files/redis-{{VERSION}}.tar.gz
   - require:
     - file: redis_dir
   - unless:
     - test -e {{REDIS_HOME}}/redis-{{VERSION}}.tar.gz

redis_pkg:
  pkg.installed:
   - pkgs: 
     - gcc
   - require:
     - file: redis_source

redis_extract:
  cmd.run:
   - cwd: {{REDIS_HOME}}
   - names: 
     - tar xvf redis-{{VERSION}}.tar.gz
   - require:
     - pkg: redis_pkg
   - unless:
     - test -e {{REDIS_HOME}}/redis-{{VERSION}}

redis_compile:
  cmd.run:
   - cwd: {{REDIS_HOME}}/redis-{{VERSION}}
   - names: 
     - make MALLOC=libc && make install
   - require:
     - cmd: redis_extract
   - unless: 
     - test -e {{REDIS_HOME}}/redis-{{VERSION}}/src
     - test -e /usr/local/bin/redis_server
