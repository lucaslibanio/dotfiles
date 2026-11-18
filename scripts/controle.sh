#!/bin/bash
# Volume e brilho com notificação (barra de progresso no dunst).
# uso: controle.sh {vol_up|vol_down|vol_mute|bright_up|bright_down}

VOL_STEP=5      # passo do volume em %
VOL_MAX=100     # o pactl deixa passar de 100%; aqui o volume para no máximo
BRIGHT_STEP=5   # passo do brilho em %

# Notificação que substitui a anterior do mesmo tipo, com barra de progresso
send_notification() {
  notify-send -h "int:value:$2" -h string:x-canonical-private-synchronous:"$1" -i "$3" "$1"
}

get_vol() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d %
}

get_bright() {
  brightnessctl -m | cut -d, -f4 | tr -d %
}

case $1 in
  vol_limit)
    # sem notificação: só traz o volume de volta para VOL_MAX se estiver acima
    # (o PipeWire restaura no boot o último volume, mesmo acima de 100%)
    v=$(get_vol)
    [ -n "$v" ] && (( v > VOL_MAX )) && pactl set-sink-volume @DEFAULT_SINK@ "${VOL_MAX}%"
    exit 0
    ;;

  vol_up)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    new=$(( $(get_vol) + VOL_STEP ))
    (( new > VOL_MAX )) && new=$VOL_MAX
    pactl set-sink-volume @DEFAULT_SINK@ "${new}%"
    send_notification "Volume" "$(get_vol)" "audio-volume-high"
    ;;

  vol_down)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    pactl set-sink-volume @DEFAULT_SINK@ "-${VOL_STEP}%"
    send_notification "Volume" "$(get_vol)" "audio-volume-low"
    ;;

  vol_mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    if [ "$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')" = "yes" ]; then
      notify-send -h string:x-canonical-private-synchronous:Volume -i "audio-volume-muted" "Volume" "Mudo"
    else
      send_notification "Volume" "$(get_vol)" "audio-volume-medium"
    fi
    ;;

  bright_up)
    brightnessctl -q set "+${BRIGHT_STEP}%"
    send_notification "Brilho" "$(get_bright)" "weather-clear"
    ;;

  bright_down)
    # nunca chega a 0%, para a tela não apagar de vez
    (( $(get_bright) > BRIGHT_STEP )) && brightnessctl -q set "${BRIGHT_STEP}%-"
    send_notification "Brilho" "$(get_bright)" "weather-clear"
    ;;

  *)
    echo "Uso: $0 {vol_up|vol_down|vol_mute|vol_limit|bright_up|bright_down}"
    exit 1
    ;;
esac
