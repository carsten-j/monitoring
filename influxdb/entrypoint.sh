#!/usr/bin/env sh

if [ ! -f "/var/lib/influxdb/.db" ]; then
    exec influxd &

    until wget "http://localhost:8086/ping" 2>/dev/null; do
        sleep 2
    done

    influx -host=localhost -port=8086 \
        -execute="CREATE DATABASE ${INFLUX_DATABASE}"

    influx -host=localhost -port=8086 \
        -execute="CREATE USER ${INFLUX_USER}" \
        "WITH PASSWORD ${INFLUX_PASSWORD}" \
        "WITH ALL PRIVILEGES"

    touch "/var/lib/influxdb/.db"

    kill -s TERM %1
fi

exec influxd