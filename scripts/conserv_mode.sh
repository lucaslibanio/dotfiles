#!/bin/bash
# Liga/desliga o modo de conservação da bateria (Lenovo IdeaPad): a carga para em ~60%.

FILE=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode

if [ ! -e "$FILE" ]; then
    echo "Este computador não tem o modo de conservação (ideapad_acpi)."
    exit 1
fi

STATUS=$(cat "$FILE")

if [ "$STATUS" = 1 ]; then
    echo 0 | sudo tee "$FILE" >/dev/null && echo "Modo de conservação desativado (carga até 100%)"
elif [ "$STATUS" = 0 ]; then
    echo 1 | sudo tee "$FILE" >/dev/null && echo "Modo de conservação ativado (carga até ~60%)"
else
    echo "Deu algum erro, não fiz nada."
    exit 1
fi
