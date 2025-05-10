#!/usr/bin/env bash

source "$SCRIPTS_DIR/list.sh"

dev_run() {
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

        # === Run Script Execution ===
        local run_script=""
        if [[ -f "$RUNS_DIR/$DISTRO/$type" ]]; then
            run_script="$RUNS_DIR/$DISTRO/$type"
        elif [[ -f "$RUNS_DIR/$type" ]]; then
            run_script="$RUNS_DIR/$type"
        fi

        if [[ -n "$run_script" ]]; then
            if [[ "$dry_run" == true ]]; then
                echo "Would run script: $run_script"
            else
                echo "Running script for $type from $run_script..."
                bash "$run_script"
            fi
        else
            echo "No run script found for $type."
        fi
    done
}

dev_run_all() {
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

    dev_run "${args[@]}" "${all_types[@]}"
}

