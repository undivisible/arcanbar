#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

lua=appls/arcanbar/arcanbar.lua

grep -q 'function arcanbar()' "$lua"
grep -q 'function arcanbar_clock_pulse()' "$lua"
grep -q 'function arcanbar_display_state()' "$lua"
grep -q 'function arcanbar_input(iotbl)' "$lua"
grep -q 'color_surface' "$lua"
grep -q 'render_text' "$lua"
grep -q 'open_rawresource' "$lua"
grep -q 'read_rawresource' "$lua"
! grep -q 'io\\.' "$lua"
! grep -q 'os\\.' "$lua"
grep -q 'show_image' "$lua"
grep -q 'resize_image' "$lua"
grep -q 'shutdown()' "$lua"
