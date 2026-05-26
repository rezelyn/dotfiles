#!/usr/bin/env bash
# required pkgs:
# - rofi
# - swaybg
# - imagemagick

WALLPAPER_DIR="$HOME/.config/hypr/wallpaper"
THEME="$HOME/.config/rofi/wallpaper.rasi"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"
mkdir -p "$THUMB_DIR"

for img in "$WALLPAPER_DIR"/*; do
    [[ -f "$img" ]] || continue
    fname=$(basename "$img")
    thumb="$THUMB_DIR/$fname.png"
    [[ -f "$thumb" ]] || convert "$img" -thumbnail 200x150^ -gravity center -extent 200x150 "$thumb" 2>/dev/null
done

INPUT_FILE=$(mktemp)
for img in "$WALLPAPER_DIR"/*; do
    [[ -f "$img" ]] || continue
    fname=$(basename "$img")
    thumb="$THUMB_DIR/$fname.png"
    printf '%s\x00icon\x1f%s\n' "$fname" "$thumb" >> "$INPUT_FILE"
done

SELECTED=$(rofi \
    -dmenu \
    -i \
    -p "Wallpaper" \
    -show-icons \
    -theme "$THEME" \
    < "$INPUT_FILE")

rm -f "$INPUT_FILE"

[ -z "$SELECTED" ] && exit 0

WALLPAPER="$WALLPAPER_DIR/$SELECTED"

if [[ ! -f "$WALLPAPER" ]]; then
    notify-send "Wallpaper" "File not found: $WALLPAPER" 2>/dev/null
    exit 1
fi

pkill swaybg
sleep 0.1
swaybg -i "$WALLPAPER" -m fill &

echo "$WALLPAPER" > "$HOME/.config/wallpaper"
notify-send -i preferences-desktop-wallpaper "Wallpaper" "Applied: $SELECTED" 2>/dev/null