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
case "$1" in
    fedora) sudo dnf install git;;
    ubuntu) sudo apt-get-install git;;
esac

#install flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#install gnome tweaks
case "$1" in
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

#install gnome icons
if [ ! -d "gnome-icons" ] ; then
    git clone https://github.com/daniruiz/flat-remix.git gnome-icons
fi
iconName="Flat-Remix-$generalColor-Dark"
mkdir -p ~/.icons/$iconName
cp "./gnome-icons/$iconName" ~/.icons/$iconName -r -f
gsettings set org.gnome.desktop.interface icon-theme $iconName