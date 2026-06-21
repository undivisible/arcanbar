#!/bin/sh
set -eu

host=${1:-}
if [ -z "$host" ]; then
	printf 'usage: %s user@host\n' "$0" >&2
	exit 64
fi

root=$(cd "$(dirname "$0")/.." && pwd)
remote=/tmp/arcanbar-ssh-smoke

ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" "rm -rf '$remote' && mkdir -p '$remote'"
rsync -a --delete --exclude .git --exclude '._*' "$root/" "$host:$remote/arcanbar/"
rsync -a --delete --exclude .git --exclude '._*' "$(dirname "$root")/polybar-upstream/" "$host:$remote/polybar-upstream/"
ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" "
	cd '$remote/arcanbar' &&
	sh ci.sh &&
	./bin/arcanbar-status &&
	ARCANBAR_MODE=parity ./bin/arcanbar-status &&
	ARCANBAR_ARCAN='${ARCANBAR_REMOTE_ARCAN:-}' sh tests/graphical_smoke.sh
"
