#! /bin/bash

tmpfile=$(mktemp /tmp/screenshot_XXXXXX.png)

maim -s "$tmpfile"

folder="$HOME/Pictures/Screenshots/"
filename=$(echo "screenshot_$(date +%d-%m-%Y_%H_%M_%S).png" | dmenu -p "Nome do arquivo:")

xclip -selection clipboard -t image/png -i "$tmpfile"

if [ -n "$filename" ]; then
    mv "$tmpfile" "$folder$filename"
else 
    rm "$tmpfile"
fi
