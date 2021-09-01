#!/usr/bin/bash
#set vars
ccash=false
grub=false
os="fedora"
generalColor="Blue"

# get flags
while [ ! $# -eq 0 ]
do
    case "$1" in
        --ccash | -c) ccash=true;;
        #--grub | -g) grub=true;; #currently broken
        --os | -o) os="$OPTARG";;
        --themeColor | -t) generalColor="$OPTARG"
    esac
    shift
done

#install git
case "$os" in
    fedora) sudo dnf install git;;
    ubuntu) sudo apt-get-install git;;
esac

#install flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#install gnome tweaks
case "$os" in
    fedora) sudo dnf install gnome-tweaks;;
    ubuntu) sudo apt-get-install gnome-tweaks;;
esac

#change grub theme
if [ "$grub" = "true" ]
then
    git clone https://github.com/sandesh236/sleek--themes.git themes
    sudo bash "./themes/Sleek theme-dark/install.sh"
fi

#~/home/.bashrc
cp ./files/.bashrc ~/.bashrc -f
if [ "$ccash" = "true" ]
then
    cat ./files/.bashrc-ccache >> ~/.bashrc
fi
source ~/.bashrc

#install gnome theme
if [ ! -d "gnome-theme" ] ; then
    git clone https://github.com/daniruiz/flat-remix-gtk.git gnome-theme
fi
themeName="Flat-Remix-GTK-$generalColor-Dark"
mkdir -p ~/.themes/$themeName
cp "./gnome-theme/$themeName" ~/.themes/$themeName -r -f
gsettings set org.gnome.desktop.interface gtk-theme $themeName
case "$os" in
    fedora) sudo dnf install flat-remix-gtk2-theme flat-remix-gtk3-theme;;
    ubuntu) sudo add-apt-repository ppa:daniruiz/flat-remix;sudo apt update;sudo apt install flat-remix-gtk;;
esac

#install gnome icons
if [ ! -d "gnome-icons" ] ; then
    git clone https://github.com/daniruiz/flat-remix.git gnome-icons
fi
iconName="Flat-Remix-$generalColor-Dark"
mkdir -p ~/.icons/$iconName
cp "./gnome-icons/$iconName" ~/.icons/$iconName -r -f
gsettings set org.gnome.desktop.interface icon-theme $iconName
case "$os" in
    fedora) sudo dnf install flat-remix-icon-theme;;
    ubuntu) sudo add-apt-repository ppa:daniruiz/flat-remix;sudo apt update;sudo apt install flat-remix;;
esac

#install vscode
case "$os" in
    fedora) sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        dnf check-update
        sudo dnf install code;;
    ubuntu) wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt install apt-transport-https
        sudo apt update
        sudo apt install code;;
esac