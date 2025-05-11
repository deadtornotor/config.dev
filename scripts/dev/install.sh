#!/usr/bin/env bash

source "$SCRIPTS_DIR/helper.sh"
source "$SCRIPTS_DIR/list.sh"

dev_install() {
    local dry_run=false
    local types=()

    # Parse options and types
    for arg in "$@"; do
        if [[ "$arg" == "--dry-run" ]]; then
            echo "Running in dry run"
            dry_run=true
        else
            types+=("$arg")
        fi
    done

    for type in "${types[@]}"; do
        echo "==> Processing type: $type"

        local package_file="$PACKAGES_DIR/$DISTRO/$type"
        if [[ ! -f "$package_file" ]]; then
            echo "No package file found for $type in $DISTRO."
            continue
        fi

        echo "Installing packages for $type from $package_file..."

        while IFS= read -r package || [[ -n "$package" ]]; do
            [[ -z "$package" || "$package" =~ ^# ]] && continue

            if [[ "$dry_run" == true ]]; then
                echo "Would install package: $package"
                continue
            fi

            case "$DISTRO" in
                ubuntu|debian)
                    sudo apt-get install -y $package
                    ;;
                arch)
                    if [[ "$type" != "yay" ]] && ! command_exists yay; then
                        echo "yay not found, installing yay first..."
                        dev_setup yay
                    fi

                    if command_exists yay; then
                        yay -S --needed --noconfirm $package
                    else
                        echo "yay not installed, falling back to pacman for $package"
                        sudo pacman -S --needed --noconfirm $package
                    fi
                    ;;
                fedora)
                    sudo dnf install -y $package
                    ;;
                opensuse)
                    sudo zypper install -y $package
                    ;;
                *)
                    echo "Unsupported distro: $DISTRO"
                    return 1
                    ;;
            esac
        done < "$package_file"
    done
}

dev_install_all() {
    local args=()

    # Preserve the --dry-run flag if passed
    if [[ "$1" == "--dry-run" ]]; then
        args+=(--dry-run)
    fi

    # Get all types
    local all_types
    mapfile -t all_types < <(dev_get)

    if [[ ${#all_types[@]} -eq 0 ]]; then
        echo "No available types found to run."
        return 1
    fi

    echo "Processing all types: ${all_types[*]}"

    dev_install "${args[@]}" "${all_types[@]}"
}
