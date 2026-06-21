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

script_path=${ARCANBAR_SCRIPT_PATH:-/tmp/arcan-src/data/scripts}
resource_path=${ARCANBAR_RESOURCE_PATH:-/tmp/arcan-src/data/resources}
bin_path=${ARCANBAR_BIN_PATH:-$(dirname "$runtime")}

timeout=${ARCANBAR_SMOKE_TIMEOUT:-3}
if command -v timeout >/dev/null 2>&1; then
	timeout "$timeout" "$runtime" -B "$bin_path" -t appls -T "$script_path" -p "$resource_path" arcanbar || code=$?
else
	"$runtime" -B "$bin_path" -t appls -T "$script_path" -p "$resource_path" arcanbar &
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
