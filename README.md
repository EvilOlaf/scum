# SCUM Dedicated Server - dockerized

## technical 

### what it contains

- stripped down Debian Bookworm with [Wine 10.0](https://gitlab.winehq.org/wine/wine/-/releases/wine-10.0)
- prepared 64-bit Wine prefix
- pre-installed [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD)
- SCUM server startup script which
- - updates steamcmd
- - installs/updates SCUM dedicated server on startup
 
### requirements

- Docker.io with or without docker compose
- 8GB memory (absolute bare minimum, COULD work if a swap-file is present but let's be honest, won't be fun. Get 16GB or at least 12GB)

### how to use?

Plain docker command:  

```bash
docker run --name scum-server -p 7777:7777/udp -p 7777:7777/tcp -p 7778:7778/udp -p 7778:7778/tcp -p 7779:7779/udp -p 7779:7779/tcp -p 27015:27015/udp -p 27015:27015/tcp -v ./scumserver-data:/opt/scumserver --restart unless-stopped ghcr.io/evilolaf/scum:main
```

**or**

`docker compose` using the example file.


## non-technical
### what?
Reverse-engineered version of j0s0n/scum-wine Docker image...

### why?
...attempting to fix some of its issues with updates and restarts.

### who?
All credits for initial work go to j0s0n.

