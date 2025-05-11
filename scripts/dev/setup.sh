#!/usr/bin/env bash

source "$SCRIPTS_DIR/install.sh"
source "$SCRIPTS_DIR/run.sh"

dev_setup() {
    local args=()
    local types=()

    # Parse options and types
    for arg in "$@"; do
        if [[ "$arg" == "--dry-run" ]]; then
            args+=(--dry-run)
        else
            types+=("$arg")
        fi
    done

    dev_install ${types[@]} ${args[@]}
    dev_run ${types[@]}
}

dev_setup_all() {
    local args=()

    # Preserve the --dry-run flag if passed
    if [[ "$1" == "--dry-run" ]]; then
        args+=(--dry-run)
    fi

    echo "Setting up all types"

    dev_install_all "${args[@]}"
    dev_run_all "${args[@]}"
}

