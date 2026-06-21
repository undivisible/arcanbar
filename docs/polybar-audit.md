# Polybar Audit

Reference clone: `../polybar-upstream`.

Polybar core shape:
- `src/components`: bar/controller/runtime ownership.
- `src/modules`: status modules.
- `src/x11`: display, EWMH, keyboard, tray, and window state.
- `src/ipc`: external control.

Arcanbar port shape:
- Arcan replaces X11 window ownership.
- `arcanbar.lua` replaces the bar renderer.
- `bin/arcanbar-status` replaces module polling.
- Alpenglowed remains the command bar and can feed status through `--polybar`.

First preserved modules:
- clock
- load
- alpenglowed mode/status

Skipped:
- X11 tray
- EWMH workspace/window modules
- C++ module ABI
- IPC socket
