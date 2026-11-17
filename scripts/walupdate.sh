#!/bin/bash
# Gera cores a partir do papel de parede (pywal) e aplica no dwm, dmenu, st e slock.
#
# uso: walupdate.sh imagem.jpg   gera as cores da imagem, troca o papel de parede e aplica
#      walupdate.sh              reaplica as últimas cores geradas
#
# O pywal sozinho só cria *.color0..15, que o st e o slock entendem. O dwm e o
# dmenu leem dwm.* e dmenu.*, por isso este script gera esse arquivo extra:
#   ~/.cache/wal/colors-suckless.Xresources  (o .xinitrc carrega no login)
set -eu

cache="$HOME/.cache/wal"

if [ $# -gt 0 ]; then
    command -v wal >/dev/null || { echo "pywal não instalado: sudo pacman -S python-pywal"; exit 1; }
    [ -f "$1" ] || { echo "Imagem não encontrada: $1"; exit 1; }
    wal -q -i "$1"
fi

if [ ! -f "$cache/colors.sh" ]; then
    echo "Nenhuma cor gerada ainda. Use: walupdate.sh imagem.jpg"
    exit 1
fi
# define $background, $foreground, $color0..$color15
. "$cache/colors.sh"

cat > "$cache/colors-suckless.Xresources" <<XRES
dwm.normbgcolor:     $background
dwm.normfgcolor:     $foreground
dwm.normbordercolor: $color8
dwm.selbgcolor:      $color4
dwm.selfgcolor:      $foreground
dwm.selbordercolor:  $color3

dmenu.background:    $background
dmenu.foreground:    $foreground
dmenu.selbackground: $color4
dmenu.selforeground: $foreground
XRES

xrdb -merge "$cache/colors.Xresources"
xrdb -merge "$cache/colors-suckless.Xresources"

# no login o .xinitrc carrega ~/.Xresources: aponta para as cores do wal,
# mas só se ele já for um link (não sobrescreve um arquivo seu)
if [ -L "$HOME/.Xresources" ] || [ ! -e "$HOME/.Xresources" ]; then
    ln -sf "$cache/colors.Xresources" "$HOME/.Xresources"
fi

xdotool key super+F5 2>/dev/null || true   # dwm: recarrega as cores
pkill -USR1 -x st 2>/dev/null || true      # st: recarrega em todos os terminais

notify-send "Cores atualizadas" "${wallpaper:-}" 2>/dev/null || true
