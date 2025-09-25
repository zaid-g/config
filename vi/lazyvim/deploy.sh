#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/nvim"

find "$SCRIPT_DIR" -type f -name "*.lua" | while read -r file; do
    rel_path="${file#$SCRIPT_DIR/}"
    target_file="$TARGET_DIR/$rel_path"
    target_dir="$(dirname "$target_file")"
    
    mkdir -p "$target_dir"
    cp "$file" "$target_file"
    echo "Copied: $rel_path"
done
