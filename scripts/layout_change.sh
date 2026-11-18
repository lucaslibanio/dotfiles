#!/bin/bash
# Alterna o teclado entre ABNT2 (br) e US internacional.

export DISPLAY=${DISPLAY:-:0}
LAYOUT=$(setxkbmap -query | awk '/layout/ {print $2}')

if [ "$LAYOUT" = br ]; then
    setxkbmap -layout us -variant intl
    msg="Teclado: US internacional"
else
    setxkbmap -layout br -variant abnt2
    msg="Teclado: ABNT2"
fi

pkill -RTMIN+6 dwmblocks 2>/dev/null   # atualiza o bloco "Kbd:" da barra
echo "$msg"
notify-send -h string:x-canonical-private-synchronous:teclado "$msg" 2>/dev/null
