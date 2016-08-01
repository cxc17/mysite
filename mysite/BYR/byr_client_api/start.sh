#!/bin/bash

source /byr/bin/activate

DIR="/byr/lib/python2.7/site-packages/byr_client_api"

gunicorn --max-requests-jitter 100 \
         --max-requests 200 \
         --timeout 120 \
         --graceful-timeout 120 \
         --paste $DIR/paste.ini \
         --access-logfile $DIR/logs/gaccess.log \
         --error-logfile $DIR/logs/error.log \
         -n byr_client_api -D \
         --access-logformat "%(h)s %(l)s %(u)s %(t)s \"%(r)s\" %(s)s %(b)s %(L)s \"%(f)s\" \"%(a)s\""

sleep 2

pid=`cat byr_client_api.pid 2>$DIR/error`

status=`ps -ef | grep byr_client_api | grep $pid | wc -l 2>$DIR/error`

if [ $status -eq 5 ]; then
    echo "byr_client_api start success, pid $pid"
else
    echo "byr_client_api start failed."
fi

deactivate
