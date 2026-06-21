#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

runtime=${ARCANBAR_ARCAN:-}

if [ -z "$runtime" ]; then
	if command -v arcan_headless >/dev/null 2>&1; then
		runtime=$(command -v arcan_headless)
	elif command -v arcan >/dev/null 2>&1; then
		runtime=$(command -v arcan)
	else
		printf 'skip: arcan runtime not found\n'
		exit 77
	fi
fi

status=${ARCANBAR_STATUS:-/tmp/arcanbar.status}
bin/arcanbar-status > "$status"

timeout=${ARCANBAR_SMOKE_TIMEOUT:-3}
if command -v timeout >/dev/null 2>&1; then
	timeout "$timeout" "$runtime" -T appls -p resources arcanbar || code=$?
else
	"$runtime" -T appls -p resources arcanbar &
	pid=$!
	sleep "$timeout"
	kill "$pid" 2>/dev/null || true
	wait "$pid" 2>/dev/null || code=$?
fi

case "${code:-0}" in
	0|124|143)
		exit 0
		;;
	*)
		exit "$code"
		;;
esac
