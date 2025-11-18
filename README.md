# SCUM Dedicated Server - dockerized

## what?
Reverse-engineered version of j0s0n/scum-wine Docker image...

## why?
...attempting to fix some of its issues with updates and restarts.

## who?
All credits for initial work goes to j0s0n.

## how to use?
Either plain docker:  

```bash
docker run --name scum-server -p 7777:7777/udp -p 7777:7777/tcp -p 7778:7778/udp -p 7778:7778/tcp -p 7779:7779/udp -p 7779:7779/tcp -p 27015:27015/udp -p 27015:27015/tcp -v ./scumserver-data:/opt/scumserver --restart unless-stopped ghcr.io/evilolaf/scum:main
```

(are all these ports even necessary? no clue...)

or

use/rename the included `docker-compose.example` file.
