#!/usr/bin/env bash
# required pkgs:
# - jq

direction=$1
current=$(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')

if [ "$direction" = "up" ]; then
  target=$(( current - 1 ))
else
  target=$(( current + 1 ))
fi

if [ "$target" -lt 1 ]; then
  target=1
fi

hyprctl dispatch workspace "$target"
