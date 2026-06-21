#!/bin/sh
set -eu
cd "$(dirname "$0")"

tests/status.sh
tests/parity.sh
tests/arcan_static.sh
if command -v luajit >/dev/null 2>&1; then
	luajit -b appls/arcanbar/arcanbar.lua /tmp/arcanbar.luac
elif command -v luac >/dev/null 2>&1; then
	luac -p appls/arcanbar/arcanbar.lua
fi
