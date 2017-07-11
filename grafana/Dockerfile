FROM grafana/grafana:4.4.1

RUN apt-get update && apt-get install -y jq gettext

WORKDIR /etc/grafana
ADD datasources ./datasources  
ADD dashboards ./dashboards  

WORKDIR /app  
COPY entrypoint.sh ./  
RUN chmod u+x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]  