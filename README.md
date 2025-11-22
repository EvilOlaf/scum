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

Note: Don't want to use *docker compose*? Check https://www.decomposerize.com/

### How to customize ports

Defaults:
- `PORT=7777` (and therefore - as per SCUM servers' weird way to assign ports - also **7778** and **7779**)
- `QUERYPORT=27015`

When `PORT` and `QUERYPORT` are altered this alteration must be done for the port mapping in docker-compose as well.  

**Example**: 
```yml
    environment:
      - PORT=10000
      - QUERYPORT=20000
    ports:
      - "10000:10000/udp"
      - "10000:10000/tcp"
      - "10001:10001/udp"
      - "10001:10001/tcp"
      - "10002:10002/udp"
      - "10002:10002/tcp"
      - "20000:20000/udp"
      - "20000:20000/tcp"
```


## Non-technical
### What?
Reverse-engineered version of j0s0n/scum-wine Docker image...

### Why?
...attempting to fix some of its issues with updates and restarts.

### Who?
All credit for the initial work goes to j0s0n.

### foot notes
I am pretty sure that some of the port exposurese are unecessary. Though I could not find any clear and straight-forward information which ports and protocols are actually necessary. Also this port calculation weirdness from SCUM does not help much either.  
Though having too much exposed here should not do any harm either.
