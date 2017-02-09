#!/bin/bash

cd /app

# remove comments in yaml, which the Python parser will interpret as separate streams.
# since we really only have one stream, fix it here rather than doing load all
for yaml in /data/config/*.yaml; do
  grep -vE "^---" /data/config/${COURSE_ENV}-users.yaml > /app/cas-users.yaml
done

if [ ! -f /data/askbot.db ]; then
  echo "No DB! Copying clean one..."
  cp /data-default/askbot.db /data/askbot.db 
fi


echo "migrate"
python manage.py migrate --noinput

cat  /data/log/askbot.log

echo "running uwsgi at ${ASKBOT_URL}..."

/usr/sbin/uwsgi /app/uwsgi.ini