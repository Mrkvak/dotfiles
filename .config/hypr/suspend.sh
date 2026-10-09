#!/bin/bash
# --daemonize returns after swaylock has secured the session. Do not background it.
if ! swaylock --daemonize --config "${XDG_CONFIG_HOME:-$HOME/.config}/swaylock/config"; then
    printf '%s\n' 'Screen locking failed; refusing to suspend.' >&2
    exit 1
fi
exec sudo /usr/local/sbin/s2ram.sh
