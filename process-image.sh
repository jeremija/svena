#!/bin/bash
GALLERY_DIR="./public/gallery"
THUMBS_DIR="./public/thumbs"
IMAGES_DIR="./public/images"
THUMB_SIZE="x400"
IMAGE_SIZE="950x"
WATERMARK='./watermark.png'

FILE="$1"

function get_file_wo_ext {
    echo $1 | sed 's|^.*/||g' | sed 's|\..*$||g'
}

function create_template {
    CURRENT_DIR="$PWD"
    mkdir -p "$GALLERY_DIR"
    file="../$(echo $1 | sed 's|./public/||g')"
    jade=$(get_file_wo_ext $file).jade
    echo "  creating template: $jade"
    cd $GALLERY_DIR
    ln -s _image.jade $jade
    cd $CURRENT_DIR
}

function resize_image {
    mkdir -p "$IMAGES_DIR"
    file="$1"
    echo "  resizing image"
    image=$(get_file_wo_ext $file).jpg

    convert "$file" -gaussian-blur 0x0.5 -resize "$IMAGE_SIZE" - | \
        composite -watermark 20% -gravity southeast "$WATERMARK" - "$IMAGES_DIR/$image"
    # composite -watermark 20% -gravity southeast "$WATERMARK" "$file" - | \
    #     convert - -resize "$IMAGE_SIZE" -gaussian-blur 0x0.5 "$IMAGES_DIR/$image"
}

function create_thumbnail {
    mkdir -p "$THUMBS_DIR"
    echo "  creating thumbs"
    image=$(get_file_wo_ext $file).jpg
    convert "$file" -resize "$THUMB_SIZE" "$THUMBS_DIR/$image"
}

function process_file {
    echo "processing file: $1"
    create_template "$1"
    resize_image "$1"
    create_thumbnail "$1"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && process_file "$FILE"
