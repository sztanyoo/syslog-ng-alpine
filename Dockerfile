FROM alpine:3.6

LABEL maintainer="Daniel Sullivan <https://github.com/mumblepins>"

ARG SYSLOG_VERSION="3.11.1"
ARG S6_OVERLAY_VERSION="1.19.1.1"

RUN apk add --no-cache \
    glib \
    pcre \
    eventlog \
    openssl \
    && apk add --no-cache --virtual .build-deps \
    curl \
    alpine-sdk \
    glib-dev \
    pcre-dev \
    eventlog-dev \
    openssl-dev \
    && set -x \
    && cd /tmp \
    && curl -sSL "https://github.com/balabit/syslog-ng/releases/download/syslog-ng-${SYSLOG_VERSION}/syslog-ng-${SYSLOG_VERSION}.tar.gz" \
        | tar xz \
    && cd "syslog-ng-${SYSLOG_VERSION}" \
    && ./configure --prefix=/usr\
    && make \
    && make install \
    && cd /tmp \
    && rm -rf "syslog-ng-${SYSLOG_VERSION}" \
    && curl -sSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" \
        | tar xz -C / \
    && apk del .build-deps \
    && mkdir -p /etc/syslog-ng \
    && mkdir -p /var/run/syslog-ng \
    && mkdir -p /var/log/syslog-ng

COPY ./etc /etc/
COPY syslog-ng.conf /home/syslog-ng.conf

VOLUME ["/var/log/syslog-ng", "/var/run/syslog-ng", "/etc/syslog-ng"]

EXPOSE 514/udp 601/tcp 6514/tcp

ENTRYPOINT ["/init"]