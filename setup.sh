#!/usr/bin/bash
#set vars
ccash=false
grub=false
os="fedora"

# get flags
while [ ! $# -eq 0 ]
do
    case "$1" in
        --ccash | -c) ccash=true;;
        --grub | -g) grub=true;;
        --os | -o) os="$OPTARG";;
    esac
    shift
done

#~/home/.bashrc
cp ./files/.bashrc ~/.bashrc -f
if [ "$ccash" = "true" ]
then
    cat ./files/.bashrc-ccache >> ~/.bashrc
fi
source ~/.bashrc

#install git
case "$1" in
    fedora) sudo dnf install git;;
    ubuntu) sudo apt-get-install git;;
esac

#change grub theme
if [ "$grub" = "true" ]
then
    git clone https://github.com/sandesh236/sleek--themes.git themes
    sudo bash "./themes/Sleek theme-dark/install.sh"
fi