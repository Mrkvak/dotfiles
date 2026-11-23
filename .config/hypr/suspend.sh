#!/bin/bash
# Lock unless already locked (e.g. via Super+L or swayidle).
# --daemonize returns after swaylock has secured the session. Do not background it.
if ! pgrep -x swaylock >/dev/null; then
    if ! swaylock --daemonize --config "${XDG_CONFIG_HOME:-$HOME/.config}/swaylock/config"; then
        printf '%s\n' 'Screen locking failed; refusing to suspend.' >&2
        exit 1
    fi
fi
exec sudo /usr/local/sbin/s2ram.sh
