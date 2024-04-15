#!/usr/bin/env bash

function help() {
	echo "start -- starts the container. requires a path as the second argument for the data directory"
	echo "stop -- stops the container"
	echo "shell -- starts interactive shell on structurizr container"
	echo "logs -- prints structurizr logs"

	exit 1
}

function start() {
	if [ -z "$1" ]; then
		echo "init command requires a valid path as data directory - Ex: $(basename) init ./structurizr"
	else
		podman run --rm --name structurizr --publish 8080:8080 --volume "$1":/usr/local/structurizr --detach docker.io/structurizr/lite
	fi
}

function stop() {
	podman stop structurizr
}

function shell() {
	podman exec -it structurizr bash
}

function logs {
	podman logs structurizr
}

[ -z "$1" ] && help

case "$1" in
"start") start "$2" ;;
"stop") stop ;;
"shell") shell ;;
"logs") logs ;;
esac
