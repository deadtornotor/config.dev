#!/usr/bin/env bash

sync_items_help ()
{
    echo "sync_items"
    echo "src_dir       source directory"
    echo "dest_dir      destination directory"
    echo "--dry-run     outputs actions that would be performed"
    echo "--nosym       copy instead of linking symbolically"
}

sync_items() {
    local src_dir="$1"
    local dest_dir="$2"
    local use_symlink=true
    local dry_run=false

    # Shift the positional arguments
    shift 2  # Skip the first two arguments (src_dir and dest_dir)

    # Parse options for --nosym and --dry-run
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --no-sym)
                use_symlink=false
                ;;
            --dry-run)
                dry_run=true
                ;;
            *)
                # If we encounter an unexpected argument, print usage
                echo "Unknown argument: $1"
                sync_items_help
                return 1
                ;;
        esac
        shift
    done

    # Ensure the source directory exists
    if [[ ! -d "$src_dir" ]]; then
        echo "Source directory '$src_dir' not found!"
        return 1
    fi

    # If dry-run is enabled, show what would happen
    if [[ "$dry_run" == true ]]; then
        echo "Dry run mode enabled. No files will be copied or symlinked."
    fi

    if [[ "$use_symlink" == true ]]; then
        echo "Using symbolic links instead of copying"
    else
        echo "Copying instead of using symbolic links"
    fi

    echo "==> Syncing from $src_dir to $dest_dir ..."

    mkdir -p "$dest_dir"

    shopt -s dotglob nullglob  # Include hidden files like .bashrc
    for item in "$src_dir"/*; do
        local base
        base="$(basename "$item")"
        local target="$dest_dir/$base"

        # If target exists, remove it

        if [[ "$dry_run" == true ]]; then
            echo "Would sync: $item -> $target"
        else
            # Remove directory
            [[ -n "$target" && "$target" != "/" ]] && rm -rf "$target"

            if [[ "$use_symlink" == true ]]; then
                ln -s "$(realpath "$item")" "$target"
                echo "Symlinked $item -> $target"
            else
                cp -r "$item" "$target"
                echo "Copied $item -> $target"
            fi
        fi
    done
    shopt -u dotglob nullglob
}

