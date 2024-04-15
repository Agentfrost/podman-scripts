#!/usr/bin/env bash

function help() {
	echo "init -- sets up the container. requires a path as the second argument for the data directory"
	echo "start -- starts the container"
	echo "stop -- stops the container"
	echo "remove -- stops and deletes the container"
	echo "shell -- starts interactive shell on structurizr container"
	echo "logs -- prints structurizr logs"

	exit 1
}

function init() {
	if [ -z "$1" ]; then
		echo "init command requires a valid path as data directory - Ex: $(basename) init ./structurizr"
	else
		podman run --name structurizr --publish 8080:8080 --volume "$1":/usr/local/structurizr docker.io/structurizr/lite
	fi
}

function start() {
	podman start structurizr
}

function stop() {
	podman stop structurizr
}

function remove() {
	podman rm structurizr
}

function shell() {
	podman exec -it structurizr bash
}

function logs {
	podman logs structurizr
}

[ -z "$1" ] && help

case "$1" in
"init") init "$2" ;;
"start") start ;;
"stop") stop ;;
"remove") remove ;;
"shell") shell ;;
"logs") logs ;;
esac
