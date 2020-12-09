#!/bin/bash

set -euo pipefail

printError()
{
    (>&2 echo $1)
}

usage()
{
    echo "Usage: $0 [parameters]"
    echo
    echo "Parameters:"
    echo "  --install-packages: install packages"
}

installPackages()
{
    install='pacman -S --needed --noconfirm'
    aurInstall='yay -S --needed --nocleanmenu --nodiffmenu --noupgrademenu --noconfirm'

    echo "Installing base packages ..."

    # for some reason not installed already. Needed by makepkg
    sudo ${install} base-devel fakeroot

    if ! command -v yay &> /dev/null; then
        mkdir -p ~/local

        git clone https://aur.archlinux.org/yay.git ~/local/yay
        pushd ~/local/yay
        makepkg -is
        popd
    fi

    ${aurInstall} gvim git aspell-en \
        maven docker \
        python python-pip unzip termite feh imagemagick \
        w3m ranger \
        mplayer \
        xorg xorg-xinit org-xmodmap \
        xdg-utils xclip \
        brave-bin \
        openssh \
        ttf-fira-code nerd-fonts-fira-code \
        asdf-vm lazygit \
        zsh antibody \
        iw bc htop \
        fzf \
        bluez bluez-utils usbutils

    # i3
    ${aurInstall} i3-gaps i3blocks i3lock i3status rofi acpi pulseaudio

    # dependencies for switch-monitor
    ${aurInstall} xorg-xrandr xdotool xorg-xprop xorg-xwininfo wmctrl

    # python stuff
    if ! command -v virtualenv &> /dev/null;
    then
        sudo pip install virtualenv
    fi

    echo "Setting up zsh ..."
    if [[ "$SHELL" != "/bin/zsh" ]];
    then
        chsh -s /bin/zsh
    fi

    echo "Setting up brave ..."
    xdg-mime default brave.desktop x-scheme-handler/http
    xdg-mime default brave.desktop x-scheme-handler/https

    echo "Initializing docker ..."
    sudo systemctl enable docker.service
    sudo systemctl start docker.service

    echo "Initializing bluetooth ..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service

    echo "Adapting user ..."
    sudo usermod -a -G video $USER
}

linkNode() {
    if (( $# < 2 ));
    then
        printError "Invalid number of arguments."
        exit 1
    fi

    relativeSource=$1
    source=$(readlink -f $relativeSource)
    destination=$2

    echo "Linking $source to $destination ..."

    if [[ -L $destination ]];
    then
        echo "File $destination exists: skipping"
    elif [[ -f $destination || -d $destination ]];
    then
        echo "File $destination exists and is regular: skipping."
    else
        ln -s $source $destination
    fi
}

if [ ! -f ./_bashrc ]; then
    printError "Run this script from within the configs repository."
    exit 1
fi

doInstallPackages=0

if (( $# > 0));
then
    case "$1" in
    --install-packages)
        doInstallPackages=1
        ;;
    *)
        printError "Unknown parameter: $1"
        usage
        exit 1
        ;;
    esac
fi

if (( $doInstallPackages == 1 ));
then
    installPackages
fi

if sudo test ! -f /etc/udev/rules.d/backlight.rules;
then
    sudo mkdir -p /etc/udev/rules.d
    sudo cp backlight.rules /etc/udev/rules.d
    sudo chown root:root /etc/udev/rules.d/backlight.rules
fi

echo "Setting up configs ..."

mkdir -p ~/.config

configs=$(find . -maxdepth 1 -name "_*")

for config in $configs
do
    # ./_vimrc -> _vimrc
    newConfig=`echo $config | sed 's#^\./##'`

    # _vimrc -> .vimrc
    newConfig=`echo $newConfig | sed 's/^_/\./'`

    newConfig=~/$newConfig

    echo "Linking $config to $newConfig ..."

    if [[ -d $config ]]; then
        echo "$config is a directory. Linking all nodes in it..."
        mkdir -p $newConfig

        for entry in $(ls $config);
        do
            relativeSource=$config/$entry
            destination=$newConfig/$entry

            linkNode "$relativeSource" "$destination"
        done
    else
        linkNode "$config" "$newConfig"
    fi
done

echo "Setting up scripts ..."
mkdir -p ~/bin
echo "directory: $(pwd)"
for script in $(ls bin);
do
    source=bin/$script
    destination=~/bin/$script

    linkNode "$source" "$destination"
done

echo "Setting up vim ..."

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
else
    echo "Vundle already installed, skipping."
fi

echo "Setting up i3blocks-contrib ..."

path=_config/i3blocks/i3blocks-contrib
if [[ ! -d $path ]];
then
    git clone https://github.com/uykusuz/i3blocks-contrib $path
else
    echo "i3blocks-contrib already present, skpping."
fi

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Done."
