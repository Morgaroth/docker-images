FROM alpine:latest
MAINTAINER derflocki

RUN apk --no-cache add minidlna

COPY entrypoint.sh /entrypoint.sh

VOLUME /config

EXPOSE 8200 1900/udp

ENTRYPOINT ["/entrypoint.sh"]
