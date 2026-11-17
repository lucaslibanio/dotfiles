#! /bin/bash

tmpfile=$(mktemp /tmp/screenshot_XXXXXX.png)
tmp_out=$(mktemp /tmp/screenshot_out_XXXXXX.png)

maim -s "$tmpfile"

if [ ! -s "$tmpfile" ]; then
    rm -f "$tmpfile" "$tmp_out"
    exit 0
fi

if [ "$1" == "-e" ]; then
    satty -f "$tmpfile" -o "$tmp_out" 2>/dev/null
    
    if [ -s "$tmp_out" ]; then
        mv "$tmp_out" "$tmpfile"
    fi
fi

xclip -selection clipboard -t image/png -i "$tmpfile"

folder="$HOME/Pictures/Screenshots/"
mkdir -p "$folder"

filename=$(echo "screenshot_$(date +%d-%m-%Y_%H_%M_%S).png" | dmenu -p "Nome do arquivo:")

if [ -n "$filename" ]; then
    if [[ "$filename" != *.png ]]; then
        filename="${filename}.png"
    fi
    mv "$tmpfile" "${folder}${filename}"
else 
    rm -f "$tmpfile"
fi

rm -f "$tmp_out"
