FROM alpine:3.6

LABEL maintainer="Daniel Sullivan <https://github.com/mumblepins>"

ARG SYSLOG_VERSION="3.11.1"
ARG S6_OVERLAY_VERSION="1.20.0.0"

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
    && apk del --no-cache .build-deps \
    && mkdir -p /etc/syslog-ng /var/run/syslog-ng /var/log/syslog-ng

COPY ./etc /etc/
COPY syslog-ng.conf /home/syslog-ng.conf

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="syslog-ng-alpine" \
      org.label-schema.description="Minimal Syslog Build on Alpine" \
      org.label-schema.url="https://hub.docker.com/r/mumblepins/syslog-ng-alpine/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

VOLUME ["/var/log/syslog-ng", "/var/run/syslog-ng", "/etc/syslog-ng"]

EXPOSE 514/udp 601/tcp 6514/tcp

ENTRYPOINT ["/init"]