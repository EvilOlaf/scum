# SCUM Dedicated Server - dockerized

> **What is this?**  
> A Docker container that runs a SCUM dedicated server on Linux.
> No manual Wine setup needed — everything is pre-configured and ready to go.

## :checkered_flag: Quick start

1. Download `docker-compose.yml`
2. Run `docker compose up -d` and **be patient**[^1]
3. Launch *SCUM* and connect to your server using port 7779

<hr>

### :arrow_right: Docker image contents

- slim *Debian Bookworm* with [*Wine* 10.0](https://gitlab.winehq.org/wine/wine/-/releases/wine-10.0)
- pre-configured 64-bit *Wine* prefix
- *SCUM server* startup script, which
- - installs/updates [*steamcmd*](https://developer.valvesoftware.com/wiki/SteamCMD)
- - installs/updates *SCUM dedicated server* on startup

### :arrow_right: Requirements

- *Linux*
- *Docker.io* with *docker compose*
- 8GB free memory (bare minimum — 16GB+ recommended)

### :question: How to use plain *Docker* without *compose*

Don't want to use *docker compose*? Check [decomposerize](https://www.decomposerize.com/).

### :question: How to customize ports

In your `docker-compose.yml` adjust `GAMEPORT`[^2] and `QUERYPORT`.

> [!WARNING]
> When `GAMEPORT` or `QUERYPORT` are altered, this change MUST reflect the port mapping as well.  
> <details>
> <summary>Example for ports 10000 and 20000:</summary>
>
>```yml
>    environment:
>      - GAMEPORT=10000
>      - QUERYPORT=20000
>    ports:
>      - "10000:10000/udp"
>      - "10000:10000/tcp"
>      - "10001:10001/udp"
>      - "10001:10001/tcp"
>      - "10002:10002/udp"
>      - "10002:10002/tcp"
>      - "20000:20000/udp"
>      - "20000:20000/tcp"
>```
>
> The port for players to connect is now **10002**.
> </details>

### :question: How to customize *SCUM server*

All server data is exposed in the `scumserver-data` folder.  
For further information check [here](https://www.google.com/search?q=scum+server+settings).

### :question: How to automatically restart every X hours

This image does not come with an automated way to periodically restart.  
You can set this up using a scheduled task (`cronjob`), like this:
`0 */6 * * * YourDockerUser cd /path/to/docker/compose/file && docker compose restart`  
Need different time or interval but lacking knowledge of cron? Check [crontab.guru](https://crontab.guru/)

### :question: How to disable *BattlEye* anti-cheat?

In your `docker-compose.yml` set `ADDITIONALFLAGS=-nobattleye`.  

### How to configure memory watchdog[^4]

Edit your `docker-compose.yml` file:
```yaml
environment:
  - MEMORY_THRESHOLD_PERCENT=95 # Stop SCUM server when system-wide memory usage exceeds %. Set 0 to disable
  - MEMORY_CHECK_INTERVAL=60    # Check interval in seconds
```

### :question: Which Docker image? `main` or `latest`?

Images tagged as `latest` are **tested and known to work.**[^3]
Any other tag represents active development and/or automated **untested** builds.  

## :information_source: Footnotes

Some port exposures are unnecessary. However, I could not find clear documentation which ports and protocols are actually required. Exposing additional ports/protocols won't cause harm.

This is a reverse-engineered[^5] version of *j0s0n/scum-wine*, fixing update/restart issues and ~~perhaps~~ adds some enhancements. Credit for the original work goes to j0s0n.

[^1]: Use `docker compose logs -f` to check the process.  
Once you see something like `scum-server  | LogBattlEye: Display: Config entry: MasterPort 8037`  
in the logs, your game server should be ready to accept player connections.

[^2]: SCUM uses 3 ports automatically: your `GAMEPORT` plus the next two (e.g., 7777 → 7778, 7779). Players connect on the **third** port (7779).  
Why this complexity? Who knows. The game developers decided this was a good idea...

[^3]: "Tested and working" means I personally joined and briefly played on the server without issues.

[^4]: SCUM server suffers from memory leaks due to poor design. Most servers restart every few hours to avoid running out of memory, which can crash the server and corrupt data. This feature tries to initiate a graceful shutdown before that happens.

[^5]: As the author of the original image [seems reluctant to provide the *Dockerfile*](https://steamcommunity.com/app/513710/discussions/0/603033663617122208/?ctp=3#c678482693017642366), I decided to take matters into my own hands.  
For the reason above the original image should be considered closed-source/proprietary.

[![GitHub tag](https://img.shields.io/github/tag/EvilOlaf/scum?include_prereleases=&sort=semver&color=blue)](https://github.com/EvilOlaf/scum/releases/)
[![stars - scum](https://img.shields.io/github/stars/EvilOlaf/scum?style=social)](https://github.com/EvilOlaf/scum)
[![EvilOlaf - scum](https://img.shields.io/static/v1?label=EvilOlaf&message=scum&color=blue&logo=github)](https://github.com/EvilOlaf/scum)
