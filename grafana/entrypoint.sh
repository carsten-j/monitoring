#!/usr/bin/env sh

if [ ! -f "/var/lib/grafana/.db" ]; then

    grafana_url="http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@localhost:3000/api/datasources"

    exec /run.sh $@ &

    until curl -s $grafana_url 2> /dev/null; do
        sleep 1
    done

    #until nc localhost 3000 < /dev/null; do sleep 1; done

    curl $grafana_url \
        -X POST -H 'Content-Type: application/json' \
        --data '{"name":"influx", "type":"influxdb", "url":"http://influxdb:8086", "access":"proxy", "isDefault":true, "database":"myaspnetcoreapp", "user":"foo","password":"bar"}'

    touch "/var/lib/grafana/.db"    

    kill $(pgrep grafana)    

fi

exec /run.sh $@