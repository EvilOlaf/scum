# SCUM Dedicated Server - dockerized

## :checkered_flag: Quick start

1. Grab the `docker-compose.yml`
2. run `docker compose up -d` and **be patient**[^1]
3. Fire up your *SCUM game* and connect using either no port or port 7779

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
- 8GB memory (absolute bare minimum, get 16GB or **at least** 12GB. 32GB or even more for large servers)

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
Though this should be easy enough to setup using a `cronjob`, like  
`0 */6 * * * YourDockerUser cd /path/to/docker/compose/file && docker compose restart`  
Need different time or interval but lacking knowledge of cron? Check [crontab.guru](https://crontab.guru/)

### :question: How to disable *BattlEye* anti-cheat?

In your `docker-compose.yml` set `ADDITIONALFLAGS=-nobattleye`.  

### How to configure memory watchdog[^5]

```yaml
environment:
  - MEMORY_THRESHOLD_PERCENT=95 # Stop SCUM server when system-wide memory usage exceeds %. Set 0 to disable
  - MEMORY_CHECK_INTERVAL=60    # Check interval in seconds
```

### :question: Which Docker image? `main` or `latest`?

Images tagged as `latest` are **tested and known to work.**[^3]
Any other tag represents active development and/or automated **untested** builds.  

## :information_source: Footnotes

I am certain some port exposures are unnecessary. However, I could not find clear documentation on which ports and protocols are actually required. The SCUM server's port calculation behaviour doesn't help either. Exposing additional ports should not cause any harm.

This image started as reverse-engineered[^4] version of the *j0s0n/scum-wine* Docker image. It attempts to fix some of its issues relating to updates and restarts and perhaps adds some enhancements. All credit for the initial work goes to j0s0n.

[^1]: Use `docker compose logs -f` to check the process.  
Once you see something like `scum-server  | LogBattlEye: Display: Config entry: MasterPort 8037`  
in the logs, your game server should be ready to accept player connections.

[^2]: SCUM has a weird way to assign the ports necessary for gameplay. It will always use two ports right after the assigned `GAMEPORT`. For example if your `GAMEPORT` is 7777, then it will always use 7778 and 7779 for various things as well. This also results in being 7779 the port for players to connect even though 7777 is configure. Ridiculous and dumb IMHO but it is what it is.

[^3]: After the SCUM game server has fully started with the specific Docker image, I launch my game client and connect to it. If I can join the game and play a bit without issues, I consider the image *tested and working*.

[^5]: SCUM game server is known for having memory leaks due to poor design which is the reason most servers are restarted every few hours. If a server runs for too long or suffers from low memory initially, it could run out of memory and therefore being forcefully killed causing potential data loss and/or corruption.  
This feature is trying to prevent this by initiating a graceful shutdown when the system-wide memory usage exceeds a specific value.

[^4]: As the author of the original image [seems reluctant to provide the *Dockerfile*](https://steamcommunity.com/app/513710/discussions/0/603033663617122208/?ctp=3#c678482693017642366), I decided to take matters into my own hands.  
For the reason above the original image should be considered closed-source/proprietary.

[![EvilOlaf - scum](https://img.shields.io/static/v1?label=EvilOlaf&message=scum&color=blue&logo=github)](https://github.com/EvilOlaf/scum "Go to GitHub repo")
[![stars - scum](https://img.shields.io/github/stars/EvilOlaf/scum?style=social)](https://github.com/EvilOlaf/scum)
[![forks - scum](https://img.shields.io/github/forks/EvilOlaf/scum?style=social)](https://github.com/EvilOlaf/scum)
[![GitHub tag](https://img.shields.io/github/tag/EvilOlaf/scum?include_prereleases=&sort=semver&color=blue)](https://github.com/EvilOlaf/scum/releases/)
![maintained - yes](https://img.shields.io/badge/maintained-yes-blue)
[![OS - Linux](https://img.shields.io/badge/OS-Linux-blue?logo=linux&logoColor=white)](https://www.linux.org/ "Go to Linux homepage")
[![Made with Docker](https://img.shields.io/badge/Made_with-Docker-blue?logo=docker&logoColor=white)](https://www.docker.com/ "Go to Docker homepage")
