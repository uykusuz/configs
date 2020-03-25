#!/bin/bash -e

printError()
{
    (>&2 echo $1)
}

printUsage()
{
    echo "Usage: $0 <options>"
    echo
    echo "Options:"
    echo "  --steps <steps>"
}

if [ ! -f ./_bashrc ]; then
    printError "Run this script from within the configs repository."
    exit 1
fi

install='pacman -S --needed'
aurInstall='yay -S --needed --nocleanmenu --nodiffmenu --noupgrademenu'
updateOnly=false

case $1 in
--update)
    updateOnly=true
    ;;
*)
    printError "unknown argument: $1"
    printUsage
    exit 1
    ;;
esac

if ! $updateOnly ; then
    echo "Installing base packages ..."

    # for some reason not installed already. Needed by makepkg
    sudo ${install} fakeroot

    sudo ${install} vim git tk gitg aspell-en tmux maven docker python npm ranger unzip termite feh ttf-ubuntu-font-family
    sudo ${install} xorg-xmodmap

    # i3
    sudo ${install} i3-gaps i3blocks i3lock i3status rofi acpi pulseaudio

    # dependencies for switch-monitor
    sudo ${install} xorg-xrandr xdotool xorg-xprop xorg-xwininfo wmctrl

    # python stuff
    sudo ${install} python-pip
    sudo pip install virtualenv

    if [[ ! -d ~/local/yay ]]; then
        mkdir -p ~/local

        git clone https://aur.archlinux.org/yay.git ~/local/yay
        pushd ~/local/yay
        makepkg -is

        popd
    fi

    echo "Installing aur packages ..."

    ${aurInstall} nerd-fonts-complete ttf-font-awesome-4 asdf-vm google-chrome lazygit

    echo "Setting up zsh ..."
    ${aurInstall} zsh zplug
    chsh -s /bin/zsh

    echo "Setting up chrome ..."

    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop x-scheme-handler/https

    echo "Initializing docker ..."
    sudo systemctl enable docker.service
    sudo systemctl start docker.service

    echo "Adapting user ..."
    sudo usermod -a -G video $USER
    sudo mkdir -p /etc/udev/rules.d
    sudo cp backlight.rules /etc/udev/rules.d
    sudo chown root:root /etc/udev/rules.d/backlight.rules
fi

echo "Copying configs ..."

mkdir -p ~/.config

configs=`find . -name "_*"`

for config in $configs
do
    # ./_vimrc -> _vimrc
    newConfig=`echo $config | sed 's#^\./##'`

    # _vimrc -> .vimrc
    newConfig=`echo $newConfig | sed 's/^_/\./'`

    echo "Copying $config to $newConfig ..."

    # copy to home directory
    if [[ -d ~/$newConfig ]]; then
        cp -R $config/* ~/$newConfig
    else
        cp -R $config ~/$newConfig
    fi
done

echo "Copying scripts ..."
mkdir -p ~/bin
cp ./bin/* ~/bin

echo "Setting up root configs ..."
sudo mkdir -p /root
sudo cp _vimrc /root/.vimrc

if ! $updateOnly ; then
    echo "Setting up vim ..."

    if [[ ! -d ~/.vim/bundle ]]; then
        mkdir -p ~/.vim/bundle
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim +PluginInstall +qall
fi

echo "Setting up i3blocks ..."

# we want to clone the custom scripts and just after it place our own config
rm -fr ~/.config/i3blocks
#git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks
git clone https://github.com/uykusuz/i3blocks-contrib ~/.config/i3blocks
cp _config/i3blocks/config ~/.config/i3blocks/


echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Done."
