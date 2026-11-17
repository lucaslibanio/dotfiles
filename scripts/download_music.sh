#!/usr/bin/env bash
set -euo pipefail

# download_music.sh
# Uso: ./download_music.sh <URL-ou-arquivo.txt> <nome-do-album> [diretório-de-saida]
if [[ $# -lt 2 ]]; then
  echo "Uso: $0 <URL-ou-arquivo.txt> <nome-do-album> [diretório-de-saida]"
  exit 1
fi

SRC="$1"
ALBUM_NAME="$2"
OUTPUT_DIR="${3:-$HOME/Music}"
mkdir -p "$OUTPUT_DIR"

run_yt_dlp() {
  local src="$1"
  yt-dlp \
    -x --audio-format mp3 --audio-quality 0 \
    --add-metadata \
    --embed-thumbnail \
    --metadata-from-title "%(artist)s - %(title)s" \
    --parse-metadata "playlist_index:%(track_number)s" \
    --parse-metadata "album:%(playlist_title)s" \
    --exec "id3v2 -A \"${ALBUM_NAME}\" {}" \
    -o "${OUTPUT_DIR}/%(artist)s/${ALBUM_NAME}/%(track_number)02d - %(title)s.%(ext)s" \
    "${src}"
}

if [[ -f "$SRC" ]]; then
  while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    echo "Baixando: $url"
    run_yt_dlp "$url"
  done < "$SRC"
else
  echo "Baixando: $SRC"
  run_yt_dlp "$SRC"
fi

echo "Concluído! Biblioteca em: $OUTPUT_DIR"

