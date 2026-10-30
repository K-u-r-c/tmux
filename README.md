# tmux

Minimalistyczny, monochromatyczny tmux **bez stałego paska statusu**. Pasek pojawia się dopiero po wciśnięciu prefixu (**Ctrl+Space**): krótki fade-in i mrugający kursor `▍`. Po następnym klawiszu znika, więc panele nigdy nie zmieniają rozmiaru i nic nie miga.

- prefix: `Ctrl+Space` (zamiast `Ctrl+b`)
- `prefix |` / `prefix -`: podział pionowy / poziomy
- `prefix h j k l`: przejście między panelami, `prefix H J K L`: zmiana rozmiaru (można powtarzać)
- `prefix r`: przeładowanie configu
- tryb kopiowania w stylu vi (`y` kopiuje), mysz włączona, historia 100 000 linii, okna numerowane od 1
- pasek: okna (`·N` paneli, `+` zoom, `•` aktywność, `!` dzwonek), tryb COPY, katalog, host, data i godzina

> Część zestawu **[linux-tools](https://github.com/K-u-r-c/linux-tools)**.

## Instalacja

Wymaga tmux ≥ 3.1 (config w `~/.config/tmux`) oraz `bash` i `awk` dla `bar-frames.sh`.

```bash
git clone https://github.com/K-u-r-c/tmux ~/.config/tmux
# ~/.tmux.conf ma pierwszeństwo przed ~/.config/tmux/tmux.conf, więc stary plik trzeba usunąć
[ -e ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.bak
```

Aktualizacja: `git -C ~/.config/tmux pull`, potem `prefix r` w działającym tmuxie.

## Pliki

| Plik | Co |
|---|---|
| `tmux.conf` | config |
| `bar-frames.sh` | generuje klatki animacji paska (fade-in i mruganie kursora); odpala go `tmux.conf` przy każdym wczytaniu |

Shell bierze z `$SHELL`. U mnie to fish, a terminal to [alacritty](https://github.com/K-u-r-c/alacritty).
