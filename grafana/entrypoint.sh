#!/usr/bin/env sh

transform_dashboard_json() {
	cat $1 | jq --arg INFLUX_DATABASE "$INFLUX_DATABASE" '.rows[0].panels[0].datasource = $INFLUX_DATABASE | { dashboard:.,overwrite: true }'
}

if [ ! -f "/var/lib/grafana/.db" ]; then

	url="http://admin:admin@localhost:3000/"

	exec /run.sh $@ &

	until curl -s ${url}"api/datasources" 2>/dev/null; do
		sleep 1
	done

	for datasource in /etc/grafana/datasources/*.json; do
		curl "${url}api/datasources" \
			-X POST -H 'Content-Type: application/json' \
			-d "$(envsubst <$datasource)"
	done

	for dashboard in /etc/grafana/dashboards/*.json; do
		dashboard_json=$(transform_dashboard_json $dashboard)
		curl "${url}api/dashboards/db" \
			-X POST -H 'Content-Type: application/json' \
			--data "$dashboard_json"
	done

	touch "/var/lib/grafana/.db"

	kill $(pgrep grafana)

fi

exec /run.sh $@
