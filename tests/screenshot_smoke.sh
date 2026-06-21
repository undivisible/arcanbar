#!/bin/sh
set -eu

host=${1:-}
if [ -z "$host" ]; then
	printf 'usage: %s user@host output.png\n' "$0" >&2
	exit 64
fi

output=${2:-/tmp/arcanbar-arcan-xvfb.png}

ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" "
	set -eu
	cd /tmp/arcanbar-ssh-smoke/arcanbar
	rm -f /tmp/arcanbar.png /tmp/arcanbar-sdl.log /tmp/ffmpeg-x11.log /tmp/xvfb.log
	./bin/arcanbar-status >/tmp/arcan-src/data/resources/arcanbar.status
	Xvfb :88 -screen 0 800x120x24 >/tmp/xvfb.log 2>&1 &
	xvfb=\$!
	sleep 1
	DISPLAY=:88 SDL_VIDEODRIVER=x11 timeout 5 /tmp/arcan-build/arcan_sdl \
		-w 800 -h 120 \
		-B /tmp/arcan-build \
		-t appls \
		-T /tmp/arcan-src/data/scripts \
		-p /tmp/arcan-src/data/resources \
		arcanbar >/tmp/arcanbar-sdl.log 2>&1 &
	app=\$!
	sleep 2
	ffmpeg -y -f x11grab -video_size 800x120 -i :88 -frames:v 1 /tmp/arcanbar.png >/tmp/ffmpeg-x11.log 2>&1
	wait \$app 2>/dev/null || true
	kill \$xvfb 2>/dev/null || true
	test -s /tmp/arcanbar.png
"

scp -q "$host:/tmp/arcanbar.png" "$output"
