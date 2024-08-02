#!/usr/bin/env bash

function help() {
	echo "init -- sets up the pod and runs the server (should be used the first time)"
	echo "start -- starts the pod (should be used from the second time onwards)"
	echo "stop -- stops the pod"
	echo "remove -- stops and deletes all containers and removes the pod"
	echo "shell -- starts interactive shell"
	echo "logs -- prints postgres logs"

	exit 1
}

function init() {
	podman pod create --name postgres-pod -p 5432:5432 &&
		podman volume create postgres-volume-1 &&
		podman run --name postgres --pod postgres-pod -e POSTGRES_PASSWORD="postgres" -v postgres-volume-1:/var/lib/postgresql/data -d docker.io/postgres
}

function start() {
	podman pod start postgres-pod
}

function stop() {
	podman pod stop postgres-pod
}

function remove() {
	podman pod rm -f postgres-pod
	podman volume rm -f postgres-volume-1
}

function shell() {
	podman exec -it postgres bash
}

function logs() {
	podman logs postgres
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
