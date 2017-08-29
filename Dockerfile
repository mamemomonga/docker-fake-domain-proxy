FROM debian:jessie

RUN set -xe && \
	rm /etc/localtime && \
	ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
	sh -c "echo 'Asia/Tokyo' > /etc/timezone" && \
	DEBIAN_FRONTEND=noninteractive apt-get update && \
	apt-get upgrade -y

RUN set -xe && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y tinyproxy dnsmasq supervisor && \
	rm -rf /var/lib/apt/lists/*

ADD files/run.sh /root/run.sh

EXPOSE 8888
VOLUME ["/data"]
CMD ["/root/run.sh"]

