#!/usr/bin/env bash

# Terminate already running bar instances
kill polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch
polybar main -q &
polybar main2 -q
