#!/bin/bash

CURRENT_DIR=$(pwd)

if [ $# -eq 0 ]; then
    (cd "$CURRENT_DIR" && st) &
else
    (cd "$CURRENT_DIR" && st "$SHELL" -c "$*; exec $SHELL") &
fi
