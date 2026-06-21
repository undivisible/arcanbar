#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

test -f ../polybar-upstream/src/components/controller.cpp
test -f ../polybar-upstream/src/modules/cpu.cpp
test -f ../polybar-upstream/src/modules/date.cpp
test -f appls/arcanbar/arcanbar.lua
test -x bin/arcanbar-status

output=$(ARCANBAR_MODE=parity bin/arcanbar-status)

case "$output" in
	"alpenglowed parity load "*)
		;;
	*)
		printf '%s\n' "$output" >&2
		exit 1
		;;
esac

grep -q 'color_surface' appls/arcanbar/arcanbar.lua
grep -q 'render_text' appls/arcanbar/arcanbar.lua
grep -q 'arcanbar_clock_pulse' appls/arcanbar/arcanbar.lua
