#!/bin/sh

set -e

echo "http://mirror.yandex.ru/mirrors/alpine/v3.4/main/"       > /etc/apk/repositories

export SYSLOG_VERSION=3.9.1

export DOWNLOAD_URL="https://github.com/balabit/syslog-ng/releases/download/syslog-ng-${SYSLOG_VERSION}/syslog-ng-${SYSLOG_VERSION}.tar.gz"

apk update

apk add glib pcre eventlog openssl openssl-dev

apk add curl alpine-sdk glib-dev pcre-dev eventlog-dev

cd /tmp
curl -L "${DOWNLOAD_URL}" > "syslog-ng-${SYSLOG_VERSION}.tar.gz"
tar zxf "syslog-ng-${SYSLOG_VERSION}.tar.gz"
cd "syslog-ng-${SYSLOG_VERSION}"
./configure --prefix=/usr
make
make install
cd ..
rm -rf "syslog-ng-${SYSLOG_VERSION}" "syslog-ng-${SYSLOG_VERSION}.tar.gz"

apk del curl alpine-sdk glib-dev pcre-dev eventlog-dev
