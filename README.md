# SCUM Dedicated Server - dockerized

## Technical 

### Docker image contents

- stripped down Debian Bookworm with [Wine 10.0](https://gitlab.winehq.org/wine/wine/-/releases/wine-10.0)
- pre-configured 64-bit Wine prefix
- SCUM server startup script, which
- - installs/updates [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD)
- - installs/updates SCUM dedicated server on startup
 
### Requirements

- Docker.io with *docker compose*
- 8GB memory (absolute bare minimum, get 16GB or **at least** 12GB. 32GB for large servers.)

### How to use

- Grab the `docker-compose.yml`
- run `docker compose up -d` and **be patient**[^1]
- Fire up your SCUM game and connect either without port or port 7779

Note: Don't want to use *docker compose*? Check https://www.decomposerize.com/


### How to customize ports

Defaults:
- `PORT=7777` and therefore (as per SCUM server's weird way to assign ports) also **7778** and **7779**
- `QUERYPORT=27015`

When `PORT` or `QUERYPORT` are altered this change MUST reflect the port mapping as well.  

**Example for ports 10000 and 20000**: 
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

The port for players to connect is now **10002**.

### How to customize SCUM server

All server data is exposed in the `scumserver-data` folder.  
For further information check [here](https://www.google.com/search?q=scum+server+settings).

### How to automatically restart every X hours?

This image does not come with an automated way to periodically restart.  
Though this should be easy enough to setup using a *cronjob*, like  
`0 */6 * * * YourDockerUser cd /path/to/docker/compose/file && docker compose restart`  
Depending on your OS, the command might be `docker-compose` instead of `docker compose`.  
Need different time or interval but lacking knowledge of cron? Check [crontab.guru](https://crontab.guru/)

### Which Docker image? `main` or `latest`?

Images tagged as `latest` are **tested and known to work.**  
Any other tag represents active development and/or automated **untested** builds.  

## Non-technical
### What?
Reverse-engineered version of j0s0n/scum-wine Docker image...

### Why?
...attempting to fix some of its issues with updates and restarts.

### Who?
All credit for the initial work goes to j0s0n.

### Footnotes
I am certain some port exposures are unnecessary. However, I could not find clear documentation on which ports and protocols are required. The SCUM server's port calculation behavior doesn't help either.  
Exposing additional ports should not cause any harm.

[^1]: Use `docker compose logs` to check the process. Once you see something like `scum-server  | LogBattlEye: Display: Config entry: MasterPort 8037` in the logs, your game server should be ready to accept player connections.
