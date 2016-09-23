#!/bin/bash
RAW_IMAGES_DIR="../svena-images"

source ./process-image.sh

for file in "$RAW_IMAGES_DIR"/*; do
    process_file "$file"
done

echo done
