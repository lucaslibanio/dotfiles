#! /bin/bash

# Cria o arquivo temporário
tmpfile=$(mktemp /tmp/screenshot_XXXXXX.png)

# O -r (--raw) faz o Flameshot exportar a imagem editada direto para o stdout
flameshot gui -r > "$tmpfile"

# Verifica se o arquivo tem tamanho zero (caso você tenha apertado ESC para cancelar o print)
if [ ! -s "$tmpfile" ]; then
    rm "$tmpfile"
    exit 0
fi

folder="$HOME/Pictures/Screenshots/"

# Chama o dmenu para pegar o nome do arquivo
filename=$(echo "screenshot_$(date +%d-%m-%Y_%H_%M_%S).png" | dmenu -p "Nome do arquivo:")

# Copia a imagem anotada para o clipboard (independente de salvar ou não no dmenu)
xclip -selection clipboard -t image/png -i "$tmpfile"

# Se o usuário digitou um nome e deu Enter, move o arquivo
if [ -n "$filename" ]; then
    mv "$tmpfile" "${folder}${filename}"
else 
    # Se o usuário apertou ESC no dmenu, apenas apaga o arquivo temporário
    rm "$tmpfile"
fi
