#!/usr/bin/env bash

if [[ ! -n "$DEV_DIR" ]]; then
    DEV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

DEV_DOT_DIR="$DEV_DIR/dots"

DEV_CONF_DIR="$DEV_DOT_DIR/conf"
DEV_HOME_DIR="$DEV_DOT_DIR/home"
DEV_ICONS_DIR="$DEV_DOT_DIR/icons"
DEV_SCRIPT_DIR="$DEV_DOT_DIR/scripts"


SCRIPTS_DIR="$DEV_DIR/scripts/dev"

PACKAGES_DIR="$DEV_DIR/packages"
RUNS_DIR="$DEV_DIR/runs"

source "$SCRIPTS_DIR/os.sh"

DISTRO=$(get_distro)
echo "Detected distro: $DISTRO"

source "$SCRIPTS_DIR/helper.sh"
source "$SCRIPTS_DIR/list.sh"
source "$SCRIPTS_DIR/install.sh"
source "$SCRIPTS_DIR/run.sh"
source "$SCRIPTS_DIR/setup.sh"
source "$SCRIPTS_DIR/sync.sh"

