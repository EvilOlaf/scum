FROM debian:trixie-slim
WORKDIR /opt

RUN apt-get update && apt-get upgrade -y
RUN apt-get install url wget unzip ca-certificates xvfb xauth x11-utils software-properties-common
RUN apt-get clean

RUN /bin/sh -c mkdir -p /opt/steamcmd && cd /opt/steamcmd && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz
ENV PATH=/opt/steamcmd:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY start-server.sh /opt/start-server.sh
RUN /bin/sh -c chmod +x /opt/start-server.sh

EXPOSE 27020/udp
EXPOSE 27015/udp
EXPOSE 7777/udp
ENV GSLT_TOKEN=
CMD ["/opt/start-server.sh"]

