#!/usr/bin/env bash
# bar-frames.sh — generuje opcje potrzebne do animacji paska tmuxa.
#
#   @bar-cursor   format wybierający kolor kursora ▍ na podstawie licznika
#                 @bar-tick: płynne mruganie (fade out / fade in), jak kursor
#                 w terminalu, który czeka na input
#   @bar-f1..fN   klatki wejścia: cały @bar coraz jaśniejszy (fade-in)
#
# Odpalany automatycznie przy każdym wczytaniu ~/.config/tmux/tmux.conf.
set -euo pipefail

# ── mruganie kursora ──────────────────────────────────────────────
# jeden cykl = $steps klatek; jasność: plateau „widoczny”, przejście,
# plateau „zgaszony”, przejście (przycięty cosinus)
steps=20
cursor=$(awk -v n="$steps" 'BEGIN {
    pi = atan2(0, -1)
    expr = ""
    for (i = n - 1; i >= 0; i--) {
        v = 0.5 + 0.9 * cos(2 * pi * i / n)
        if (v > 1) v = 1
        if (v < 0) v = 0
        c = sprintf("#%02x%02x%02x", 0x16 + v * (0xff - 0x16), 0x16 + v * (0xff - 0x16), 0x16 + v * (0xff - 0x16))
        expr = (expr == "") ? c : sprintf("#{?#{==:#{e|%%:#{@bar-tick},%d},%d},%s,%s}", n, i, c, expr)
    }
    print expr
}')
tmux set -g @bar-cursor "$cursor"

# ── klatki wejścia ────────────────────────────────────────────────
tpl=$(tmux show -gv @bar)
while [[ $tpl =~ \#\{E:(@[a-z0-9-]+)\} ]]; do
    name=${BASH_REMATCH[1]}
    val=$(tmux show -gv "$name")
    tpl=${tpl//"#{E:$name}"/"$val"}
done

# jasność kolejnych klatek i grubość znacznika
factors=(0.15 0.4 0.7)
accents=(▏ ▎ ▍)

for i in "${!factors[@]}"; do
    frame=$(awk -v f="${factors[$i]}" '{
        out = ""
        while (match($0, /#[0-9a-fA-F]{6}/)) {
            hex = substr($0, RSTART + 1, 6)
            col = "#"
            for (j = 0; j < 3; j++) {
                v = 0
                for (k = 1; k <= 2; k++)
                    v = v * 16 + index("0123456789abcdef", tolower(substr(hex, j * 2 + k, 1))) - 1
                col = col sprintf("%02x", int(v * f + 0.5))
            }
            out = out substr($0, 1, RSTART - 1) col
            $0 = substr($0, RSTART + RLENGTH)
        }
        print out $0
    }' <<<"$tpl")
    frame=${frame//▍/${accents[$i]}}
    tmux set -g "@bar-f$((i + 1))" "$frame"
done
