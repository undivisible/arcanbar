#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

lua=${LUA:-}
if [ -z "$lua" ]; then
	if command -v luajit >/dev/null 2>&1; then
		lua=luajit
	elif command -v lua >/dev/null 2>&1; then
		lua=lua
	else
		printf 'skip: lua runtime not found\n'
		exit 77
	fi
fi

status=${TMPDIR:-/tmp}/arcanbar-status-file.$$
trap 'rm -f "$status"' EXIT
printf 'file sourced status\n' > "$status"

ARCANBAR_STATUS=$status "$lua" - <<'LUA'
local rendered = nil

VRESW = 640
CLOCK = 0

function valid_vid(value)
	return value ~= nil
end

function delete_image()
end

function color_surface()
	return "bg"
end

function move_image()
end

function order_image()
end

function show_image()
end

function resize_image()
end

function render_text(lines)
	rendered = lines[1]
	return "text"
end

function shutdown()
end

dofile("appls/arcanbar/arcanbar.lua")
arcanbar()

if not rendered or not string.find(rendered, "file sourced status", 1, true) then
	error(rendered or "no rendered text")
end
LUA
