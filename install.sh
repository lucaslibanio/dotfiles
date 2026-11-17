#!/usr/bin/env bash
# Instala o ambiente (dwm, dmenu, st, slock, dwmblocks + scripts e configs)
# num Arch Linux.
#
# uso: ./install.sh              tudo: pacotes, compilar, links
#      ./install.sh --extras     também instala os pacotes de packages-extras.txt
#      ./install.sh --sem-pacotes  pula o pacman
#      ./install.sh --so-links     só cria os links das configs e scripts
#
# Arquivos que já existirem no lugar de um link são renomeados para
# <nome>.bak-<data>, nunca apagados.
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
PROGRAMAS=(my-dwm dmenu st slock dwmblocks)

pacotes=1 compilar=1 extras=0
for arg in "$@"; do
    case "$arg" in
        --extras)       extras=1 ;;
        --sem-pacotes)  pacotes=0 ;;
        --so-links)     pacotes=0; compilar=0 ;;
        -h|--help)      sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Opção desconhecida: $arg (use --help)"; exit 1 ;;
    esac
done

passo() { printf '\n\033[1;33m==> %s\033[0m\n' "$*"; }
aviso() { printf '\033[1;31m!!  %s\033[0m\n' "$*"; }

# link <origem no repositório> <destino em $HOME>
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        echo "   ok      $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bak-$STAMP"
        echo "   backup  $dst -> $dst.bak-$STAMP"
    fi
    ln -s "$src" "$dst"
    echo "   link    $dst -> $src"
}

lista() { grep -v '^\s*#' "$1" | tr -s ' \n' '\n' | grep -v '^$'; }

# ---------------------------------------------------------------- pacotes
if (( pacotes )); then
    if ! command -v pacman >/dev/null; then
        aviso "pacman não encontrado: este script é para Arch. Use --sem-pacotes."
        exit 1
    fi
    passo "Instalando pacotes (packages.txt)"
    lista "$DOT/packages.txt" | sudo pacman -S --needed --noconfirm -
    if (( extras )); then
        passo "Instalando pacotes opcionais (packages-extras.txt)"
        lista "$DOT/packages-extras.txt" | sudo pacman -S --needed --noconfirm -
    fi
fi

# ---------------------------------------------------------------- submódulos
passo "Baixando os submódulos (dwm, dmenu, st, slock, dwmblocks)"
git -C "$DOT" submodule update --init --recursive

# ---------------------------------------------------------------- ~/.source
# O dwmblocks procura os scripts em ~/.source/dwmblocks/scripts
if [ "$DOT" != "$(readlink -f "$HOME/.source" 2>/dev/null || true)" ]; then
    passo "Ligando ~/.source a $DOT"
    link "$DOT" "$HOME/.source"
fi

# ---------------------------------------------------------------- compilar
if (( compilar )); then
    for p in "${PROGRAMAS[@]}"; do
        passo "Compilando e instalando $p"
        (
            cd "$DOT/$p"
            [ -f config.h ] || [ ! -f config.def.h ] || cp config.def.h config.h
            make clean >/dev/null
            make
            sudo make install
        )
    done
fi

# ---------------------------------------------------------------- links
passo "Criando links das configs e scripts"
link "$DOT/scripts"               "$HOME/Scripts"
link "$DOT/config/dunst/dunstrc"  "$HOME/.config/dunst/dunstrc"
link "$DOT/config/Xresources"     "$HOME/.Xresources"
[ -f "$DOT/config/xinitrc" ]     && link "$DOT/config/xinitrc"     "$HOME/.xinitrc"
[ -f "$DOT/config/xprofile" ]    && link "$DOT/config/xprofile"    "$HOME/.xprofile"
mkdir -p "$HOME/Pictures/Screenshots"

# ---------------------------------------------------------------- avisos
case ":$PATH:" in
    *":$HOME/Scripts:"*) ;;
    *) aviso "~/Scripts não está no PATH. O dwm chama controle.sh, dmenu_mount etc. por lá."
       echo "    Adicione ao seu .xinitrc (antes do exec dwm):  export PATH=\"\$HOME/Scripts:\$PATH\"" ;;
esac
locale -a 2>/dev/null | grep -qi '^pt_BR.utf8$' ||
    aviso "Locale pt_BR.UTF-8 não gerado: a data na barra e no slock fica em inglês (veja /etc/locale.gen)."

passo "Pronto. Entre no X com startx (ou reinicie o dwm com Super+Ctrl+Shift+Q)."
echo "    Atalhos e mudanças: $DOT/TUTORIAL.html e $DOT/my-dwm/MUDANCAS.html"
