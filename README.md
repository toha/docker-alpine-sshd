# SSHD

Alpine Linux Image which exposes a ssh daemon with support for tunneling traffic.

## Build

```
docker build -t alpine-sshd .
```

## Run

```
docker run --name sshd-run -p PUBLIC_SSH_PORT:22 -p REVERSE_PROXY_LISTEN_IP:9001:9001 -d alpine-sshd
```

