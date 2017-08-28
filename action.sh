#!/bin/bash
set -eu

NIMAGE=fake-domain-proxy
NCONTAINER=dfp01

do_purge() {
	if [ -n "$(docker ps -a --filter name=$NCONTAINER --format={{.ID}})" ]; then
		echo "docker stop $NCONTAINER"
		docker stop $NCONTAINER || true
		echo "docker rm $NCONTAINER"
		docker rm $NCONTAINER || true
	fi
}

do_run() {
	do_purge
	echo "docker build $NCONTAINER"
	docker build -t fake-domain-proxy .
	echo "docker run $NCONTAINER"
	docker run -d --name $NCONTAINER -p 8888:8888 -v $(pwd)/data:/data $NIMAGE
}

do_usage() {
	echo "USAGE: $(basename $0) [ purge | run | bash | supervisorctl ]"
	exit 1
}

case "${1:-}" in
	"purge" ) do_purge ;;
	"run"   ) do_run ;;
	"bash" ) exec docker exec -it $NCONTAINER bash ;;
	"supervisorctl" ) exec docker exec -it $NCONTAINER supervisorctl ;;
	*       ) do_usage ;;
esac

