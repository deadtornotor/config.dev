#!/usr/bin/env bash

source "$SCRIPTS_DIR/helper.sh"

dev_get() {
    local run_types_generic=""
    local run_types_distro=""
    local package_types=""

    if [[ -d "$RUNS_DIR" ]]; then
        run_types_generic=$(find "$RUNS_DIR" -maxdepth 1 -type f -exec basename {} \;)
    fi

    if [[ -d "$RUNS_DIR/$DISTRO" ]]; then
        run_types_distro=$(find "$RUNS_DIR/$DISTRO" -type f -exec basename {} \;)
    fi

    if [[ -d "$PACKAGES_DIR/$DISTRO" ]]; then
        package_types=$(find "$PACKAGES_DIR/$DISTRO" -type f -exec basename {} \;)
    fi

    # Print unique types (sorted)
    echo -e "$run_types_generic\n$run_types_distro\n$package_types" | sort -u
}

dev_list() {
    echo "Available types:"
    dev_get
}

