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

    shift 2  # Skip the first two arguments (src_dir and dest_dir)

    # Parse options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --no-sym)
                use_symlink=false
                ;;
            --dry-run)
                dry_run=true
                ;;
            *)
                echo "Unknown argument: $1"
                sync_items_help
                return 1
                ;;
        esac
        shift
    done

    if [[ ! -d "$src_dir" ]]; then
        echo "Source directory '$src_dir' not found!"
        return 1
    fi

    [[ "$dry_run" == true ]] && echo "Dry run mode enabled. No files will be copied or symlinked."
    [[ "$use_symlink" == true ]] && echo "Using symbolic links instead of copying" || echo "Copying instead of using symbolic links"
    echo "==> Syncing from $src_dir to $dest_dir ..."

    shopt -s dotglob nullglob

    find "$src_dir" -type f | while IFS= read -r file; do
        # Compute relative path
        local rel_path="${file#$src_dir/}"
        local target="$dest_dir/$rel_path"

        if [[ "$dry_run" == true ]]; then
            echo "Would sync: $file -> $target"
        else
            # Ensure target directory exists
            mkdir -p "$(dirname "$target")"

            # Remove existing file only
            [[ -e "$target" ]] && rm -f "$target"

            if [[ "$use_symlink" == true ]]; then
                ln -s "$(realpath "$file")" "$target"
                echo "Symlinked $file -> $target"
            else
                cp "$file" "$target"
                echo "Copied $file -> $target"
            fi
        fi
    done

    shopt -u dotglob nullglob
}

