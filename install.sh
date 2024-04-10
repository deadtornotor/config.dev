# Install some required packages
pacman -S --needed git base-devel go flatpak


# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..


# Install all hyprland packages and "needed" packages for it to work
yay -S hyprland hyprpaper hyprlock hyprpicker alacritty grim slurp wofi thunar pavucontrol pipewire lib32-pipewire wireplumber polkit-kde-agent waybar xwayland


# Install fonts and themes
yay -S ttf-ms-win11-auto ttf-font-awesome ttf-roboto
yay -S capitaine-cursors candy-icons arc-gtk-theme 


# Install GTK and QT for configuration
yay -S qt6-base qt5-base gtk3 gtk4


# Install other usefull default applications
yay -S neovim neofetch portmaster-stub-bin steam brave-bin discord xdg-desktop-portal-hyprland xdg-desktop-portal xdg-desktop-portal-gtk 

flatpak install org.mozilla.firefox com.github.tchx84.Flatseal org.kde.krita org.onlyoffice.desktopeditors com.github.PintaProject.Pinta com.spotify.Client

# Compilers and Struff
yay -S gcc jre-openjdk jre8-openjdk jre17-openjdk python

# Copy the .config folder
mkdir ~/.config/
mkdir ~/.themes/
mkdir ~/.icons/

cp -f ./.config/ ~/.config/
cp -f ./.themes/ ~/.themes/
cp -f ./.icons/ ~/.icons/
cp -f ./.bashrc ~/.bashrc


# Install Login manager and start it to finish installation
yay -S sddm

systemctl enable --now sddm
