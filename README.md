# arcanbar

Polybar-shaped status surface for Arcan.

This is a fresh port target, not a C++ fork. Polybar stays cloned at `../polybar-upstream` as reference. Arcanbar keeps the useful model: small modules produce text, one bar surface renders it, actions stay external.

## Run

```sh
arcan -t appls -T /path/to/arcan/data/scripts -p /path/to/arcan/data/resources arcanbar
```

Feed it:

```sh
bin/arcanbar-status > /tmp/arcanbar.status
```

## Shape

- `appls/arcanbar/arcanbar.lua`: Arcan appl.
- `bin/arcanbar-status`: Polybar-equivalent module collector.
- `tests/status.sh`: smallest runnable check.

## Polybar Reference

Polybar has X11-specific bar, tray, IPC, and window modules. Arcanbar keeps module output and drops X11 ownership. Arcan owns display, input, and client integration.

## Screenshot

![Arcanbar running through Arcan SDL in Xvfb](docs/arcanbar-arcan-xvfb.png)

## Smoke

```sh
./ci.sh
```

This checks the Polybar reference clone, module output, and Arcan Lua surface calls.

Optional graphical smoke:

```sh
tests/graphical_smoke.sh
tests/ssh_smoke.sh undivisible@192.168.4.134
tests/screenshot_smoke.sh undivisible@192.168.4.134 docs/arcanbar-arcan-xvfb.png
```

`graphical_smoke.sh` exits `77` when no `arcan` or `arcan_headless` runtime is installed.
