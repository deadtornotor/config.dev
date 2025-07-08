# Basics


## Layout

```text
config.dev/
├─ lua/
│  ├─ common/
│  │  ├─ ~.lua
├─ linux/wsl/
│  ├─ install/
│  │  ├─ <distro>/
│  ├─ run/
│  │  ├─ <distro>/
│  │  ├─ <common>
│  ├─ dots/
│  │  ├─ conf/
│  │  ├─ home/
│  │  ├─ icons/
├─ windows/
│  ├─ install/
│  ├─ run/
│  ├─ dots/
```


## lua/common

The common directory contains cross platform scripts that are always going to be run with the runs

> These are run after the run specific scripts inside linux/wsl/windows are run
>
> This is to let the platform specific stuff create a layout usable on all systems

## Linux/WSL

The Linux/WSL directories contain wsl/linux specific stuff

### Install

Inside of the install directory files with the names of the packages are stored

> The <\distro> directory is the name of the linux distribution

#### Example

```text
gcc cmake python jdk-openjdk clang gradle meson
cpio pkg-config ninja git
base-devel fzf
```

### Run

Inside of the run directory there are bash scripts which can run

> The <\distro> directory is the name of the linux distribution
>
> Scripts inside of run/ directory instead of run/<\distro> will be run after the bash script of the specific distribution

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


### Dots

The dots directory contains dot files which will be copied/linked on the system
