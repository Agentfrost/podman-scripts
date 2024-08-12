#!/usr/bin/env bash

function help() {
	echo "init -- sets up the pod and runs the server (should be used the first time)"
	echo "start -- starts the pod (should be used from the second time onwards)"
	echo "stop -- stops the pod"
	echo "remove -- stops and deletes all containers and removes the pod"
	echo "shell -- starts interactive shell"
	echo "logs -- prints container logs"

	exit 1
}

function init() {
	podman pod create --name plantuml-pod -p 9876:8080 &&
		podman run --name plantuml --pod plantuml-pod -d docker.io/plantuml/plantuml-server:latest
}

function start() {
	podman pod start plantuml-pod
}

function stop() {
	podman pod stop plantuml-pod
}

function remove() {
	podman pod rm -f plantuml-pod
}

function shell() {
	podman exec -it plantuml bash
}

function logs() {
	podman logs plantuml
}

[ -z "$1" ] && help

case "$1" in
"init") init ;;
"start") start ;;
"stop") stop ;;
"remove") remove ;;
"shell") shell ;;
"logs") logs ;;
esac
