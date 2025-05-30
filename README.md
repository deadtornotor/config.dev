# config.dev 
 
This is my utility for setting up my linux environment


## Commands

| Command |  Used to |
| --- | --- |
| `./setup` | Copies all dot files |
| `./setup help` | Show help for options |
| `./setup list` | List all packages/types that can be setup via the script |
| `./setup install`  | Install all types |
| `./setup install {<types>}`  | Install specified type |
| `./setup run`  | Run all scripts assosiated with the types |
| `./setup run {<types>}`  | Run script assosiated with the types |
| `./setup setup`  | Setup everything (runs `install` and `run`) |
| `./setup install {<types>}`  | Setup specified types (runs `install` and `run`) |


### Additional arguments

| Argument | Usage |
| --- | --- |
| `--no-sym` | Copies the dot files instead of creating symbolic links |
| `--dry-run` | Shows you what would happen if you ran the command |


> Dotfiles always get synced if not run with `--dry-run` or `help` is used


## Distros

This currently only supports Arch-Linux


## Hyprland

> Since I use this on multiple devices my hyprland setup with monitors changes and some other minor stuff


### hypr/hw/hypr.conf

Imported at the start of the hyprland configuration.
Set things like workspaces, monitor layout, etc.

#### Example

```conf
monitor=DP-1,2560x1440@60,0x0,1
```


### hypr/hw/lock.conf

set screen with $screen = xyz

set wallpaper with $wallpaper = xyz

#### Example

```conf
$screen = DP-1
$wallpaper = ~/.config/hypr/backgrounds/red_abyss.png
```


### hypr/hyprpaper.conf

regularly set the wallpaper with it

#### Example

```conf
wallpaper = DP-1, $dir/window.png
```

## Setup

    The package and script run files that are for the same package/type should be called the same

### Packages

The packages are just packages which should be installed.

Packages are define in the `packages/%distro%/` directory and contain a list of packages to be downloaded.

#### Example 

```text
gcc cmake python jdk-openjdk clang gradle meson
cpio pkg-config ninja git
base-devel fzf
```

### Script runs

Scripts are bash scripts run after installation for configuration or building packages from source.

Scripts are define in the `runs/` directory.

There are two types of scripts:

- Distro independent | defined in the directory itself
- Distro specific | defined in a `%distro%/` directory inside of `runs/`

> If there is a Distro specific script the distro independent one will not be run

#### Example

```bash
#!/usr/bin/env bash


command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "==> Installing yay if not already installed..."
if ! command_exists yay; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -fr yay
else
    echo "yay is already installed."
fi

```

