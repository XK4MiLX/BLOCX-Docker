ARG UBUNTUVER=20.04
FROM ubuntu:${UBUNTUVER}
LABEL com.centurylinklabs.watchtower.enable="true"
RUN mkdir -p /root/.pivx
RUN apt-get update && apt-get install -y  tar wget curl pwgen jq
RUN wget https://github.com/PIVX-Project/PIVX/releases/download/v5.5.0/pivx-5.5.0-x86_64-linux-gnu.tar.gz -P /tmp
RUN cd /tmp && tar -C /usr/local/bin --strip 1 -xf /tmp/pivx-5.5.0-x86_64-linux-gnu.tar.gz
COPY node_initialize.sh /node_initialize.sh
COPY check-health.sh /check-health.sh
VOLUME /root/.pivx
RUN chmod 755 node_initialize.sh check-health.sh
EXPOSE 51472
HEALTHCHECK --start-period=5m --interval=5m --retries=5 --timeout=15s CMD ./check-health.sh
CMD ./node_initialize.sh
