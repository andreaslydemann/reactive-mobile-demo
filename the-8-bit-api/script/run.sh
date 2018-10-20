#!/usr/bin/env bash

set -e

PIDFILE="./tmp/pids/server.pid"
if [ -f "${PIDFILE}" ]; then
   rm "${PIDFILE}"
fi

docker-compose up
