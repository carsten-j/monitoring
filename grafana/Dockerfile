FROM grafana/grafana:4.3.2

WORKDIR /etc/grafana
COPY grafana.ini ./
ADD dashboards ./dashboards  

WORKDIR /app  
COPY entrypoint.sh ./  
RUN chmod u+x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]  