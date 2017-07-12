#!/usr/bin/env sh

transform_dashboard_json() {
    cat $1 | jq --arg INFLUX_DATABASE "$INFLUX_DATABASE" '.rows[0].panels[0].datasource = $INFLUX_DATABASE | { dashboard:. ,overwrite: true }'
}

if [ ! -f "/var/lib/grafana/.db" ]; then

    url="http://${GRAFANA_USER}:${GRAFANA_PASSWORD}@localhost:3000/"

    exec /run.sh $@ &

    # consider exiting to avoid infinite loop
    until curl -s ${url}"api/datasources" 2>/dev/null; do
        sleep 2
    done

    # try with -u for user:password
    for datasource in /etc/grafana/datasources/*.json; do
        curl "${url}api/datasources" \
            POST -H 'Content-Type: application/json' \
            --data "$(envsubst <$datasource)"
    done

    for dashboard in /etc/grafana/dashboards/*.json; do
        dashboard_json=$(transform_dashboard_json $dashboard)
        curl "${url}api/dashboards/db" \
            POST -H 'Content-Type: application/json' \
            --data "$dashboard_json"
    done

    touch "/var/lib/grafana/.db"

    kill $(pgrep grafana)

fi

exec /run.sh $@