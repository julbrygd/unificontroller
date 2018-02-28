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
COPY root/ /
RUN apk -U add --no-cache libstdc++ && \
	mkdir /var/lib/unifi && \
	ln -s /var/lib/unifi /srv/unifi/data && \
	mkdir /var/log/unifi && \
	ln -s /var/log/unifi /srv/unifi/logs && \
	ln -s /dev/stdout /srv/unifi/logs/server.log && \
	mkdir /var/run/unifi && \
	ln -s /var/run/unifi /srv/unifi/run


ENTRYPOINT "/usr/bin/entrypoint.sh"
CMD ["unifictl", "start"]