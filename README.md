## Syslog-ng in Client - Server pair in Alpine Docker


### Basic Info
Minimal syslog-ng server container that writes logs to `/var/log/syslog-ng/$HOST/$PROGRAM.log`.

Another minimal syslog-ng as client that checks `/var/log/syslog-ng/my.log` and sends all received lines to the server.

Modified from [mumblepins-docker/syslog-ng-alpine](https://github.com/mumblepins-docker/syslog-ng-alpine), and the [balabit docker image's](https://github.com/balabit/syslog-ng-docker) config file (which isn't included in that build...)

Includes a default config file if none specified, or alternatively use your own by binding `/etc/syslog-ng`.

Uses Tini for monitoring

Exposed inputs:

* 514/udp
* 601/tcp
* 6514/TLS
* unix socket `/var/run/syslog-ng/syslog-ng.sock`

Exposed Volumes:
* `/var/log/syslog-ng` (Actual logging location)
* `/var/run/syslog-ng` (Unix Socket)
* `/etc/syslog-ng` (Config File)

#### Usage

1. Start the containers
```
docker-compose up -d
```

2. Write some data to the client side
```
echo "some test data" | sudo tee -a syslog-ng-client/logs/my.log
```

3. Check the data on the server side
```
sudo find syslog-ng-server/logs -type f -exec cat {} \;
```