FROM alpine as build
ENV UNIFI_VERSION=5.6.30

RUN apk -U add --no-cache -t build-deps binutils curl && \
	mkdir /data && \
	cd /data && \
	curl -OL https://dl.ubnt.com/unifi/${UNIFI_VERSION}/UniFi.unix.zip && \
	curl -OL https://dl.ubnt.com/unifi/${UNIFI_VERSION}/unifi_sh_api && \
	unzip UniFi.unix.zip && \
	mv unifi_sh_api UniFi/bin/ && \
	apk --no-cache del build-deps 
	

FROM frolvlad/alpine-oraclejdk8:latest
LABEL maintainer="Stephan Conrad <stephan@conrad.pics>"

COPY --from=build /data/UniFi /srv/unifi
RUN apk -U add --no-cache libstdc++
