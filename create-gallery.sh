#!/bin/bash
GALLERY_DIR="./public/view"
IMAGES_DIR="../svena-images"
THUMBS_DIR="./public/thumbs"
THUMB_SIZE="x400"

function get_file_wo_ext {
    echo $1 | sed 's|^.*/||g' | sed 's|\..*$||g'
}

function create_templates {
    echo creating templates...
    mkdir -p "$GALLERY_DIR"

    for file in "$IMAGES_DIR"/*; do
        file="../$(echo $file | sed 's|./public/||g')"
        # jade=$(echo $file | sed 's|^.*/||g' | sed 's|\..*$||g').jade
        jade=$(get_file_wo_ext $file).jade
        echo   creating template for $file as $jade
        cp './public/_image.jade' "$GALLERY_DIR/$jade"
        # cat ./public/_image.jade | sed "s|{{image}}|$file|g" > "$GALLERY_DIR/${jade,,}.jade"
    done

    echo templates done
}

function create_thumbnails {
    echo creating thumbnails...
    mkdir -p "$THUMBS_DIR"

    for file in "$IMAGES_DIR"/*; do
        echo "  creating thumbs for $file"
        image=$(get_file_wo_ext $file).jpg
        convert "$file" -resize "$THUMB_SIZE" "$THUMBS_DIR/$image"
        echo $file
    done

    echo thumbnails done
}

create_templates
create_thumbnails

echo done
