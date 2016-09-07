#!/bin/bash
GALLERY_DIR="./public/gallery"
RAW_IMAGES_DIR="../svena-images"
THUMBS_DIR="./public/thumbs"
IMAGES_DIR="./public/images"
THUMB_SIZE="x400"
IMAGE_SIZE="950x"
WATERMARK='./watermark.png'

function get_file_wo_ext {
    echo $1 | sed 's|^.*/||g' | sed 's|\..*$||g'
}

function create_templates {
    echo creating templates...
    mkdir -p "$GALLERY_DIR"

    CURRENT_DIR=$PWD
    for file in "$RAW_IMAGES_DIR"/*; do
        file="../$(echo $file | sed 's|./public/||g')"
        # jade=$(echo $file | sed 's|^.*/||g' | sed 's|\..*$||g').jade
        jade=$(get_file_wo_ext $file).jade
        echo   creating template for $file as $jade
        cd $GALLERY_DIR
        ln -s _image.jade $jade
        cd $CURRENT_DIR

    done

    echo templates done
}

function resize_images {
    echo resizing images...
    mkdir -p "$IMAGES_DIR"
    for file in "$RAW_IMAGES_DIR"/*; do
        echo "  resizing image $file"
        image=$(get_file_wo_ext $file).jpg

        convert "$file" -gaussian-blur 0x0.5 -resize "$IMAGE_SIZE" - | \
            composite -watermark 20% -gravity southeast "$WATERMARK" - "$IMAGES_DIR/$image"
        # composite -watermark 20% -gravity southeast "$WATERMARK" "$file" - | \
        #     convert - -resize "$IMAGE_SIZE" -gaussian-blur 0x0.5 "$IMAGES_DIR/$image"
    done

    echo resizing done
}

function create_thumbnails {
    echo creating thumbnails...
    mkdir -p "$THUMBS_DIR"

    for file in "$RAW_IMAGES_DIR"/*; do
        echo "  creating thumbs for $file"
        image=$(get_file_wo_ext $file).jpg
        convert "$file" -resize "$THUMB_SIZE" "$THUMBS_DIR/$image"
    done

    echo thumbnails done
}

create_templates
resize_images
create_thumbnails

echo done
