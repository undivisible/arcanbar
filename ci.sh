#!/bin/sh
set -eu
cd "$(dirname "$0")"

tests/status.sh
if command -v luac >/dev/null 2>&1; then
	luac -p appls/arcanbar/arcanbar.lua
fi
