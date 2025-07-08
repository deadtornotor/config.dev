#!/usr/bin/env bash

get_distro() {
    if [[ -f /etc/os-release ]]; then
        # Source the os-release file
        . /etc/os-release
        echo "$ID"  # Outputs 'arch', 'ubuntu', 'debian', 'opensuse', etc.
    else
        echo "unknown"
    fi
}

is_wsl() {
    if [[grep -iF "microsoft" /proc/version]]; then
        echo 1
    else
        echo 0
    fi
}
