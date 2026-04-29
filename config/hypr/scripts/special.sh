#!/usr/bin/env bash

WORKSPACE="$1"
CLASS="$2"
CMD="$3"

if ! hyprctl clients -j | grep -q "\"class\": \"$CLASS\""; then
    hyprctl dispatch exec "[workspace special:$WORKSPACE silent] $CMD"
fi

hyprctl dispatch togglespecialworkspace "$WORKSPACE"
