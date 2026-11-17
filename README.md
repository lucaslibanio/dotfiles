# dotfiles

Meu ambiente no Arch Linux: **dwm** + **dwmblocks** + **dmenu** + **st** + **slock**,
os scripts do `~/Scripts` e as configs que eles usam.

## Instalar num computador novo

```sh
git clone --recursive https://github.com/lucaslibanio/dotfiles.git ~/.source
cd ~/.source
./install.sh            # pacotes + compilar + links
startx
```

O clone precisa ir para `~/.source`: o dwmblocks procura os scripts dele lá.

Opções do `install.sh`:

| opção | o que faz |
|---|---|
| *(nenhuma)* | instala `packages.txt`, compila os 5 programas e cria os links |
| `--extras` | também instala `packages-extras.txt` (yt-dlp, scrcpy, wacom, tlp…) |
| `--sem-pacotes` | não usa o pacman |
| `--so-links` | só cria os links (útil no computador atual) |

Nenhum arquivo é apagado: o que já existir no lugar de um link vira `<nome>.bak-<data>`.

## O que tem aqui

| caminho | o que é | vira |
|---|---|---|
| `my-dwm/` | dwm *(submódulo)* | `/usr/local/bin/dwm` |
| `dmenu/` | dmenu + `dmenu_power`, `dmenu_emoji` *(submódulo)* | `/usr/local/bin/` |
| `st/` | st + `st-urlhandler` *(submódulo)* | `/usr/local/bin/` |
| `slock/` | slock *(submódulo)* | `/usr/local/bin/slock` |
| `dwmblocks/` | barra de status + scripts dos blocos *(submódulo)* | `/usr/local/bin/dwmblocks` |
| `scripts/` | scripts do dia a dia | link em `~/Scripts` |
| `config/dunst/dunstrc` | notificações | link em `~/.config/dunst/dunstrc` |
| `config/xinitrc` | inicialização do X | link em `~/.xinitrc` |
| `config/Xresources` | tema padrão (sem pywal) | link em `~/.Xresources` |
| `cheats/` | colas de atalhos (uma por programa, em inglês) | lidas pelo `cheats` |
| `TUTORIAL.html` | atalhos e recursos de dmenu, st e slock | |
| `my-dwm/MUDANCAS.html` | atalhos do dwm | |

## Scripts

| script | atalho no dwm | o que faz |
|---|---|---|
| `controle.sh` | teclas de volume/brilho | volume (máx. 100%) e brilho com notificação |
| `screenshot_satty.sh` | `Super+Shift+A` / `S` | print de uma área; `-e` abre o editor |
| `dmenu_display` | `Super+Shift+D` | estendido, espelhado, só notebook, só externo |
| `dmenu_mount` | `Super+Shift+M` | monta/desmonta pendrives sem sudo |
| `layout_change.sh` | | alterna teclado ABNT2 ↔ US internacional |
| `cheats` | `Super+F1` | colas de atalhos: `cheats st` no terminal, `--menu` no dmenu, `--check` confere com os config.h |
| `tema` | `Super+Shift+T` | liga/desliga as cores do pywal; `tema imagem.jpg` gera cores novas |
| `cripto_pendrive.sh` | | abre/fecha pendrive LUKS (`open /dev/sdb1`) |
| `conserv_mode.sh` | | modo de conservação da bateria (IdeaPad) |
| `camera_cell` | | celular como webcam (scrcpy) |
| `download_music.sh` | | baixa álbuns com yt-dlp |
| `mesa_config.sh` | | mapeia a mesa Wacom |
| `pomodoro` | | timer pomodoro no terminal |

## Dia a dia

Cada programa é um repositório próprio (submódulo). Para mudar o dwm, por exemplo:

```sh
cd ~/.source/my-dwm
# edita, compila, testa...
git commit -am "..." && git push
cd ~/.source
git commit -am "Atualiza dwm" && git push   # registra a versão nova no dotfiles
```

Para trazer as atualizações em outro computador:

```sh
cd ~/.source && git pull && git submodule update --init --recursive && ./install.sh --sem-pacotes
```
