FROM grafana/grafana:4.4.1

WORKDIR /etc/grafana
ADD dashboards ./dashboards  

WORKDIR /app  
COPY entrypoint.sh ./  
RUN chmod u+x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]  