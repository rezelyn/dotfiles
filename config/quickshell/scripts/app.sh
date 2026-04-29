#!/usr/bin/env bash

APP="$1"
CMD="$2"

if [[ -z "$APP" || -z "$CMD" ]]; then
  echo "Usage: $0 <app> <toggle|status|visible>"
  exit 1
fi

case "$CMD" in
  toggle)
    if ! hyprctl clients -j | grep -q "\"class\": \"$APP\""; then
      hyprctl dispatch exec ""[workspace special:$APP silent] "$APP"
    fi
    hyprctl dispatch togglespecialworkspace "$APP"
    ;;
  status)
    if hyprctl clients -j | grep -q "\"class\": \"$APP\""; then
      echo "true"
    else
      echo "false"
    fi
    ;;
  visible)
    hyprctl monitors -j | grep -q "\"name\": \"special:$APP\"" \
      && echo "true" || echo "false"
    ;;
  *)
    echo "Unknown command: $CMD"
    exit 1
    ;;
esac
