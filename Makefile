.PHONY: init clean

CONFIG_PY_FILES=data/etc/dnsmasq.d/address.dnsmasq.conf data/etc/tinyproxy.filter.conf etc/Config

init: $(CONFIG_PY_FILES) data/etc data/logs

$(CONFIG_PY_FILES): etc/config.yaml data/etc
	bin/config.py

data/etc:
	mkdir -p $@
	mkdir -p $@/dnsmasq.d
	cp -f files/etc/dnsmasq.conf $@
	cp -f files/etc/tinyproxy.conf $@
	cp -f files/etc/supervisor.conf $@

data/logs:
	mkdir -p $@
	touch data/logs/dnsmasq.log
	touch data/logs/tinyproxy.log

clean:
	rm -rf data/etc data/logs

