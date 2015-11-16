#!/bin/bash

WATERMARK='./watermark.png'
OUT_DIR='./public/images'

function add_overlay {
    echo processing $1
    IN="$1"
    OUT=$(basename $IN)

    # convert "$IN" -gravity center \( "$WATERMARK" -alpha set -channel A -evaluate set 60% \) -compose screen -composite "$OUT_DIR/$OUT"
    composite -watermark 20% -tile -gravity center "$WATERMARK" "$IN" "$OUT_DIR/$OUT"
}

function add_single_overlay {
    composite -watermark 20% -gravity southeast "$WATERMARK" "../svena-images/bonaca.jpg" "./public/assets/bg0.jpg"
}

# for file in "../svena-images/"*; do
#     add_overlay "$file"
# done

add_single_overlay
