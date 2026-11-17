#!/bin/sh
STYLUS="Wacom Intuos S Pen stylus"
PAD="Wacom Intuos S Pad pad"

xsetwacom set "$STYLUS" MapToOutput HDMI-A-0
xsetwacom set "$STYLUS" Area 0 0 15200 8550
xsetwacom set "$PAD" Button 1 "key ctrl z"
xsetwacom set "$PAD" Button 2 "key ctrl shift z"
xsetwacom set "$PAD" Button 3 "key e"
xsetwacom set "$PAD" Button 8 "key ctrl s"
