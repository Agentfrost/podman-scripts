#!/usr/bin/env bash

function help() {
	echo "init -- sets up the pod and runs the server (should be used the first time)"
	echo "start -- starts the pod (should be used from the second time onwards)"
	echo "stop -- stops the pod"
	echo "remove -- stops and deletes all containers and removes the pod"
	echo "shell-postgres -- starts interactive shell on postgres container"
	echo "shell-susperset -- starts interactive shell on susperset container"
	echo "logs-postgres -- prints postgres logs"
	echo "logs-superset -- prints superset logs"

	exit 1
}

function init() {
	podman pod create --name superset-eval -p 8080:8088 &&
		podman volume create postgres-volume-1 &&
		podman run --name postgres --pod superset-eval -e POSTGRES_PASSWORD="postgres" -v postgres-volume-1:/var/lib/postgresql/data -d docker.io/postgres &&
		podman run --name superset --pod superset-eval -e SUPERSET_SECRET_KEY="secret_key" -d docker.io/apache/superset &&
		podman exec -it superset superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@superset.com --password admin &&
		podman exec -it superset superset db upgrade &&
		# podman exec -it superset superset load_examples &&
		podman exec -it superset superset init &&
		podman exec -it superset bash -c "pip install psycopg2-binary"
}

function start() {
	podman pod start superset-eval
}

function stop() {
	podman pod stop superset-eval
}

function remove() {
	podman pod rm -f superset-eval
	podman volume rm -f postgres-volume-1
}

function shell-postgres() {
	podman exec -it postgres bash
}

function shell-superset() {
	podman exec -it superset bash
}

function logs-postgres() {
	podman logs postgres
}

function logs-superset() {
	podman logs superset
}

[ -z "$1" ] && help

case "$1" in
"init") init ;;
"start") start ;;
"stop") stop ;;
"remove") remove ;;
"shell-postgres") shell-postgres ;;
"shell-susperset") shell-susperset ;;
"logs-postgres") logs-postgres ;;
"logs-superset") logs-superset ;;
esac
