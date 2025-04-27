#!/bin/bash

set -e  # Exit on any error

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}


USE_SYMLINK=false
if [[ "$1" == "sym" ]]; then
    USE_SYMLINK=true
    echo "-> Using symbolic links instead of copying."
fi


echo "==> Installing yay if not already installed..."
if ! command_exists yay; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed."
fi

echo "==> Installing packages from packages.txt..."
if [[ -f packages.txt ]]; then
    yay -Syyu --needed --noconfirm $(<packages.txt)
else
    echo "packages.txt not found!"
fi

echo "==> Enabling Deamons..."

systemctl enable --now portmaster tuned tuned-ppd

systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse

echo "==> Installing flatpak if not already installed..."
if ! command_exists flatpak; then
    sudo pacman -S --noconfirm flatpak
else
    echo "flatpak is already installed."
fi

echo "==> Installing flatpak apps from flatpak.txt..."
if [[ -f flatpaks.txt ]]; then
    flatpak install -y $(<flatpaks.txt)
else
    echo "flatpaks.txt not found!"
fi

echo "==> Syncing config directories from conf/ to ~/.config/..."
if [[ -d conf ]]; then
    mkdir -p ~/.config
    for dir in conf/*; do
        base=$(basename "$dir")
        target="$HOME/.config/$base"
        rm -rf "$target"
        if $USE_SYMLINK; then
            ln -s "$(realpath "$dir")" "$target"
            echo "Symlinked $dir -> $target"
        else
            cp -r "$dir" "$target"
            echo "Copied $dir -> $target"
        fi
    done
else
    echo "conf directory not found!"
fi

echo "==> Syncing dotfiles from home/ to ~..."

if [[ -d home ]]; then
    shopt -s dotglob nullglob  # Include hidden files
    for file in home/*; do
        base="$(basename "$file")"  # Prefix with dot
        [[ $base != .* ]] && base=".$base"
        target="$HOME/$base"
        
        if [[ -n "$target" && "$target" != "/" ]]; then
            rm -rf "$target"
        fi

        if $USE_SYMLINK; then
            ln -s "$(realpath "$file")" "$target"
            echo "Symlinked $file -> $target"
        else
            cp -r "$file" "$target"
            echo "Copied $file -> $target"
        fi
    done
    shopt -u dotglob nullglob  # Clean up
else
    echo "home directory not found!"
fi


echo "==> Syncing icons directories from icons/ to ~/.icons/..."
if [[ -d icons ]]; then
    mkdir -p ~/.icons
    for dir in icons/*; do
        base=$(basename "$dir")
        target="$HOME/.icons/$base"
        rm -rf "$target"
        if $USE_SYMLINK; then
            ln -s "$(realpath "$dir")" "$target"
            echo "Symlinked $dir -> $target"
        else
            cp -r "$dir" "$target"
            echo "Copied $dir -> $target"
        fi
    done
else
    echo "icons directory not found!"
fi

echo "✅ All done!"

