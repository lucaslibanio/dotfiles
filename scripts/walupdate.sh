#!/bin/bash
# Mantido por compatibilidade: agora é o comando "tema" (veja tema --help).
exec "$(dirname "$0")/tema" "${@:-on}"
