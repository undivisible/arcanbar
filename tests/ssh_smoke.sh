#!/bin/sh
set -eu

host=${1:-}
if [ -z "$host" ]; then
	printf 'usage: %s user@host\n' "$0" >&2
	exit 64
fi

root=$(cd "$(dirname "$0")/.." && pwd)
archive=/tmp/arcanbar-ssh-smoke.tgz
remote=/tmp/arcanbar-ssh-smoke
stage=/tmp/arcanbar-ssh-smoke-stage

rm -rf "$stage"
mkdir -p "$stage/arcanbar" "$stage/polybar-upstream"
git -C "$root" archive HEAD | tar -C "$stage/arcanbar" -xf -
git -C "$(dirname "$root")/polybar-upstream" archive HEAD | tar -C "$stage/polybar-upstream" -xf -
tar -C "$stage" -czf "$archive" arcanbar polybar-upstream

scp -q "$archive" "$host:$archive"
ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" "
	rm -rf '$remote' &&
	mkdir '$remote' &&
	tar -C '$remote' -xzf '$archive' &&
	cd '$remote/arcanbar' &&
	sh ci.sh &&
	./bin/arcanbar-status &&
	ARCANBAR_MODE=parity ./bin/arcanbar-status &&
	sh tests/graphical_smoke.sh
"
