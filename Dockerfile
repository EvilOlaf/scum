FROM debian:trixie-slim
WORKDIR /opt

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget unzip ca-certificates xvfb xauth x11-utils
RUN apt-get install -y wine wine64 wine32 libwine libwine:i386 winbind
RUN apt-get clean

RUN mkdir -p /opt/steamcmd && cd /opt/steamcmd && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz
ENV PATH=/opt/steamcmd:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY start-server.sh /opt/start-server.sh
RUN chmod +x /opt/start-server.sh

EXPOSE 27020/udp
EXPOSE 27015/udp
EXPOSE 7777/udp
ENV GSLT_TOKEN=
CMD ["/opt/start-server.sh"]
