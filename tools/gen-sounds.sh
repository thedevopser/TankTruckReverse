#!/usr/bin/env bash
#
# (Re)génère les sons de Media/ de façon reproductible, via ffmpeg (Docker).
# Sources & licences : voir Media/CREDITS.md. Les sons réels sont téléchargés
# depuis des dépôts libres (CC0 / CC BY-SA) puis coupés/normalisés ; le sonar et
# le placeholder voix sont synthétisés. backup_beep.ogg n'est PAS régénéré ici
# (voir sa recette dans CLAUDE.md).
#
# Chaque .ogg reste remplaçable par un meilleur échantillon en écrasant le
# fichier — le registre Core/Sounds.lua ne bouge pas.
#
# Usage : tools/gen-sounds.sh
set -euo pipefail

cd "$(dirname "$0")/.."
IMG=jrottenberg/ffmpeg:latest
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
OUT="-ac 1 -ar 44100 -c:a libvorbis -q:a 5 -y"

ff() { docker run --rm --entrypoint ffmpeg -v "$TMP":/w -v "$(pwd)/Media":/out -w /w "$IMG" "$@"; }

echo "→ Téléchargement des sources libres…"
# Canard — Wikimedia Commons, CC BY-SA 4.0 (Ganesh Mohan T).
curl -sSL "https://upload.wikimedia.org/wikipedia/commons/d/d0/Domestic_duck_sound_01.wav" -o "$TMP/duck.wav"
# Klaxon — Wikimedia Commons, CC0 (15HPanska_Ruttner_Jan / Freesound 461679).
curl -sSL "https://upload.wikimedia.org/wikipedia/commons/8/8c/Car_Horn.wav" -o "$TMP/horn.wav"
# Blip 8-bit — pack « 50 CC0 Sci-Fi SFX », CC0.
curl -sSL "https://raw.githubusercontent.com/lavenderdotpet/CC0-Public-Domain-Sounds/main/50-cc0-sci-fi-sfx/retro_beep_01.ogg" -o "$TMP/retro.ogg"

echo "→ Traitement…"
# Canard : cluster de « coin coin » (8,90–10,20 s), coupé + normalisé.
ff -ss 8.90 -t 1.30 -i duck.wav \
   -af "afade=t=in:st=0:d=0.02,afade=t=out:st=1.20:d=0.08,loudnorm=I=-11:TP=-1" \
   $OUT /out/duck_quack.ogg

# Klaxon : un coup net (premier honk, 0,50–0,83 s), normalisé.
ff -ss 0.50 -t 0.33 -i horn.wav \
   -af "afade=t=in:st=0:d=0.008,afade=t=out:st=0.28:d=0.04,loudnorm=I=-11:TP=-1" \
   $OUT /out/horn.ogg

# Blip 8-bit : tel quel, mono + normalisé.
ff -i retro.ogg -af "loudnorm=I=-11:TP=-1" $OUT /out/retro_blip.ogg

# Sonar : ping sinus 800 Hz + queue d'écho (synthétisé).
ff -f lavfi -i "aevalsrc='sin(2*PI*800*t)*exp(-3.5*t)':d=0.9:s=44100" \
   -af "aecho=0.8:0.9:160:0.4,afade=t=out:st=1.7:d=0.2,loudnorm=I=-12:TP=-1" \
   $OUT /out/sonar_ping.ogg

echo "→ Sons régénérés dans Media/ (voir Media/CREDITS.md)"
