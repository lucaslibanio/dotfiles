#!/bin/bash

# partição criptografada; dá para trocar: cripto_pendrive.sh open /dev/sdb1
DEVICE="${2:-/dev/sda1}"
MAPPER_NAME="pendrive_crypt"
MAPPER_PATH="/dev/mapper/$MAPPER_NAME"
MOUNT_POINT="/mnt/pendrive"

open_pen() {
    # segurança: só abre se for mesmo uma partição LUKS (o /dev/sda1 de
    # outro computador pode ser o disco do sistema)
    if [ "$(lsblk -no FSTYPE "$DEVICE" 2>/dev/null)" != "crypto_LUKS" ]; then
        echo "[ERRO] $DEVICE não é uma partição criptografada (LUKS)."
        echo "Partições disponíveis:"
        lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT
        exit 1
    fi
    echo "[*] Desbloqueando..."
    sudo cryptsetup open "$DEVICE" "$MAPPER_NAME" || {
        echo "[ERRO] Falha ao desbloquear."
        exit 1
    }
    
    echo "[*] Criando ponto de montagem..."
    sudo mkdir -p "$MOUNT_POINT"

    echo "[*] Montando filesystem..."
    sudo mount "$MAPPER_PATH" "$MOUNT_POINT" || {
        echo "[ERRO] Falha ao montar."
        exit 1
    }

    echo "[OK] Pendrive montado em $MOUNT_POINT"
}

close_pen() {
    echo "[*] Desmontando..."
    sudo umount "$MOUNT_POINT" || {
        echo "[ERRO] Falha ao desmontar."
        exit 1
    }
    
    echo "[*] Fechando criptografia..."
    sudo cryptsetup close "$MAPPER_NAME" || {
        echo "[ERRO] Falha ao fechar LUKS"
    }

    echo "[OK] Pendrive fechado com segurança."
}

case "$1" in
    open)
        open_pen 
        ;;
    close)
        close_pen 
        ;;
    *)
        echo "Uso: $0 {open|close} [dispositivo, padrão /dev/sda1]"
        exit 1
        ;;
esac
