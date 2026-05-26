#!/usr/bin/env bash
# required pkgs:
# - jq

WORKSPACE="$1"
CLASS="$2"
CMD="$3"

if ! hyprctl clients -j | jq -e --arg c "$CLASS" 'any(.[]; .class == $c)' > /dev/null; then
    hyprctl dispatch exec "[workspace special:$WORKSPACE silent] $CMD"
fi

hyprctl dispatch togglespecialworkspace "$WORKSPACE"
