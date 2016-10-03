FROM alpine:3.4
MAINTAINER Getty Images "https://github.com/gettyimages"

EXPOSE 9088

RUN addgroup exporter \
 && adduser -S -G exporter exporter

COPY . /go/src/github.com/gettyimages/marathon_exporter

RUN apk --update add ca-certificates \
 && apk --update add --virtual build-deps go git \
 && cd /go/src/github.com/gettyimages/marathon_exporter \
 && GOPATH=/go go get \
 && GOPATH=/go go build -o /marathon_exporter \
 && apk del --purge build-deps \
 && rm -rf /go/bin /go/pkg /var/cache/apk/*

USER exporter

ENTRYPOINT ["/marathon_exporter"]
