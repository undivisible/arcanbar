#!/bin/sh
set -eu

output=$(ARCANBAR_MODE=test ./bin/arcanbar-status)

case "$output" in
	"alpenglowed test load "*)
		exit 0
		;;
	*)
		printf '%s\n' "$output" >&2
		exit 1
		;;
esac
