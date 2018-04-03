#!/bin/bash
#set -e # chown may fail on readonly mounts

if [[ "$@" == 'eswrapper' ]]; then
        find /usr/share/elasticsearch/config -type f -exec chmod 600 {} ';' &> /dev/null
        find /usr/share/elasticsearch/config -type d -exec chmod 700 {} ';' &> /dev/null
        chown -R elasticsearch /usr/share/elasticsearch/config 2> /dev/null
fi

exec /usr/local/bin/docker-entrypoint.sh "$@"
