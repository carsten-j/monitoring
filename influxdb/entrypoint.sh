#!/usr/bin/env sh
#set -e

if [ ! -f "/var/lib/influxdb/.db" ]; then
	exec influxd &

	#LOOP_MAX_COUNT=12
	#LOOP_INCREMENT_COUNT=1
	#LOOP_COUNT_SLEEP=5

	until wget "http://localhost:8086/ping" 2>/dev/null; do
	#	if ($LOOP_INCREMENT_COUNT >= $LOOP_MAX_COUNT); then
	#		break
	#	fi
	#	LOOP_INCREMENT_COUNT+=1
		sleep 2 # $LOOP_COUNT_SLEEP
	done

	influx -host=localhost -port=8086 \
		-execute="CREATE DATABASE ${INFLUX_DATABASE}"

	influx -host=localhost -port=8086 \
		-execute="CREATE USER ${INFLUX_USER} " \
		"WITH PASSWORD ${INFLUX_PASSWORD} " \
		"WITH ALL PRIVILEGES"

	touch "/var/lib/influxdb/.db"

	kill -s TERM %1
fi

exec influxd
