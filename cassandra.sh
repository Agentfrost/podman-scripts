#!/usr/bin/env bash

function help() {
	echo "init -- sets up the pod and runs the server (should be used the first time)"
	echo "start -- starts the pod (should be used from the second time onwards)"
	echo "stop -- stops the pod"
	echo "remove -- stops and deletes all containers and removes the pod"
	echo "shell -- starts interactive shell"
	echo "cqlsh -- starts interactive cqlsh"
	echo "logs -- prints logs"

	exit 1
}

function init() {
	podman pod create --name cassandra -p 9042:9042 &&
		podman volume create cassandra-server-1-volume &&
		podman run --name cassandra-server-1 --pod cassandra -v cassandra-server-1-volume:/var/lib/cassandra -d docker.io/cassandra:5
}

function start() {
	podman pod start cassandra
}

function stop() {
	podman pod stop cassandra
}

function remove() {
	podman pod rm -f cassandra
	podman volume rm -f cassandra-server-1-volume
}

function cqlsh() {
	podman run -it --pod cassandra --rm --name cassandra-cqlsh docker.io/cassandra:5 cqlsh cassandra-server-1
}

function shell() {
	podman exec -it cassandra-server-1 bash
}

function logs() {
	podman logs cassandra-server-1
}

[ -z "$1" ] && help

case "$1" in
"init") init ;;
"start") start ;;
"stop") stop ;;
"remove") remove ;;
"shell") shell ;;
"cqlsh") cqlsh ;;
"logs") logs ;;
esac
