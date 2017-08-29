#!/bin/bash
set -eu
BASEDIR=$( perl -MCwd -MFile::Basename -e 'print Cwd::abs_path(dirname($ARGV[0])."/../")' $0)
source $BASEDIR/etc/Config

do_purge() {
	if [ -n "$(docker ps -a --filter name=$DCR_CONTAINER --format={{.ID}})" ]; then
		echo "docker stop $DCR_CONTAINER"
		docker stop $DCR_CONTAINER || true
		echo "docker rm $DCR_CONTAINER"
		docker rm $DCR_CONTAINER || true
	fi
}

do_run() {
	do_purge
	echo "docker build $DCR_CONTAINER"
	docker build -t fake-domain-proxy .
	echo "docker run $DCR_CONTAINER"
	docker run -d --name $DCR_CONTAINER -p $DCR_HOST_PORT:8888 -v $(pwd)/data:/data $DCR_IMAGE
	docker exec $DCR_CONTAINER supervisorctl status
}

do_usage() {
	echo "USAGE: $(basename $0) [ purge | run | bash | supervisorctl | restart ]"
	exit 1
}


case "${1:-}" in
	"purge" ) do_purge ;;
	"run"   ) do_run ;;
	"bash" ) exec docker exec -it $DCR_CONTAINER bash ;;
	"supervisorctl" ) exec docker exec -it $DCR_CONTAINER supervisorctl $@;;
	"restart" ) docker exec $DCR_CONTAINER supervisorctl restart dnsmasq tinyproxy ;;
	"start"   ) docker exec $DCR_CONTAINER supervisorctl start   dnsmasq tinyproxy ;;
	"stop"    ) docker exec $DCR_CONTAINER supervisorctl stop    dnsmasq tinyproxy ;;
	"status"  ) docker exec $DCR_CONTAINER supervisorctl status ;;
	*       ) do_usage ;;
esac

