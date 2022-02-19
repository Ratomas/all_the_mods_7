# syntax=docker/dockerfile:1

FROM openjdk:8u312-jdk-buster

LABEL version="0.2.41"

RUN apt-get update && apt-get install -y curl unzip dos2unix && \
 addgroup minecraft && \
 adduser --home /data --ingroup minecraft --disabled-password minecraft

COPY launch.sh /launch.sh
RUN dos2unix /launch.sh
RUN chmod +x /launch.sh

COPY server-setup-config.yaml /server-setup-config.yaml
RUN dos2unix /server-setup-config.yaml

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD "All the Mods 7 version 0.2.41 Server Powered by Docker"
ENV LEVEL world
ENV LEVELTYPE ""
ENV JVM_OPTS "-Xms2048m -Xmx4096m"
