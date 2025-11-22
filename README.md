# SCUM Dedicated Server - dockerized

## Technical 

### Docker image contents

- stripped down Debian Bookworm with [Wine 10.0](https://gitlab.winehq.org/wine/wine/-/releases/wine-10.0)
- pre-configured 64-bit Wine prefix
- pre-installed [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD)
- SCUM server startup script, which
- - updates steamcmd
- - installs/updates SCUM dedicated server on startup
 
### Requirements

- Docker.io, with or without docker compose
- 8GB memory (absolute bare minimum, COULD work if a swap-file is present but let's be honest, won't be fun. Get 16GB or at least 12GB)

### How to use

- Grab the `docker-compose.yml`
- run `docker compose up -d`

### How to customize ports

By default the ports **7777** (and therefore - as per SCUM servers' weird way to assign ports - also **7778** and **7779**) and the query port **27015**.  
When `PORT` and `QUERYPORT` are altered this alteration must be done for the port mapping in docker-compose as well.  

**Example**: 

## Non-technical
### What?
Reverse-engineered version of j0s0n/scum-wine Docker image...

### Why?
...attempting to fix some of its issues with updates and restarts.

### Who?
All credit for the initial work goes to j0s0n.

