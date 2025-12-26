FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="SCUM Server"
LABEL org.opencontainers.image.description="Docker image for running a SCUM game server with Wine and SteamCMD on Debian Bookworm"
LABEL org.opencontainers.image.version="1.4.0"
LABEL org.opencontainers.image.authors="EvilOlaf"
LABEL org.opencontainers.image.url="https://github.com/EvilOlaf/scum"
LABEL org.opencontainers.image.source="https://github.com/EvilOlaf/scum"
LABEL org.opencontainers.image.base.name="debian:bookworm-slim"

WORKDIR /opt

# system stuff
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get upgrade -y && apt-get install -y locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# wine, steamcmd
RUN apt-get install -y wget unzip ca-certificates xvfb xauth x11-utils software-properties-common gnupg
RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --install-recommends winbind winehq-stable && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV WINEDEBUG=-all
ENV WINEARCH=win64
ENV WINEPREFIX=/opt/wine64
ENV XDG_RUNTIME_DIR=/tmp
ENV PATH=/opt/steamcmd:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN wineboot --init

# scum server run script
COPY start-server.sh /opt/start-server.sh
RUN chmod +x /opt/start-server.sh

EXPOSE 27020/udp
EXPOSE 27015/udp
EXPOSE 27015/tcp
EXPOSE 7777/udp
EXPOSE 7777/tcp
EXPOSE 7778/udp
EXPOSE 7778/tcp
EXPOSE 7779/udp
EXPOSE 7779/tcp
ENV GSLT_TOKEN=
CMD ["/opt/start-server.sh"]
