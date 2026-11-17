#!/bin/bash
# Aplica as cores do pywal (~/.cache/wal) em todo o ambiente.
# uso: wal -i imagem.jpg && walupdate.sh

ln -sf ~/.cache/wal/colors.Xresources ~/.Xresources
cat ~/.Xresources ~/.cache/wal/xrdb_extra 2>/dev/null | xrdb -merge

xdotool key super+F5        # dwm: recarrega as cores (o atalho era Alt+F5)
pkill -USR1 -x st           # st: recarrega as cores em todos os terminais
pkill -x dunst              # dunst: reabre com as cores novas na próxima notificação
