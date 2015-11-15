#!/bin/sh
set -e

sudo yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum install -y --enablerepo=remi redis
sudo systemctl start redis
sudo systemctl enable redis

sudo sh -c "sed '/ExecStart=/s|/etc/redis\.conf|& --port 6380|' /usr/lib/systemd/system/redis.service > /etc/systemd/system/redis-6380.service"
sudo systemctl start redis-6380
sudo systemctl enable redis-6380

sudo sh -c "sed '/ExecStart=/s|/etc/redis\.conf|& --port 6381|' /usr/lib/systemd/system/redis.service > /etc/systemd/system/redis-6381.service"
sudo systemctl start redis-6381
sudo systemctl enable redis-6381

sudo sh -c "cat > /etc/nutcracker.conf <<'EOF'
alpha:
  listen: 127.0.0.1:22121
  hash: fnv1a_64
  distribution: ketama
  auto_eject_hosts: true
  redis: true
  server_retry_timeout: 2000
  server_failure_limit: 1
  servers:
    - 127.0.0.1:6379:1
    - 127.0.0.1:6380:1
    - 127.0.0.1:6381:1
EOF
"
