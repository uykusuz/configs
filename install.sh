#!/bin/bash

printError()
{
    (>&2 echo $1)
}

if [ ! -f ./_bashrc ]; then
    printError "Run this script from within the configs repository."
    exit 1
fi

exitCode=0
startStep=0

if [ $startStep -eq 0 ]; then
    echo "Installing base packages ..."

    sudo pacman -S vim git tk gitg aspell-en tmux fish maven docker

    # i3
    sudo pacman -S i3 dmenu acpi
    mkdir -p ~/.config
    git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks

    # dependencies for switch-monitor
    sudo pacman -S xorg-xrandr xdotool xorg-xprop xorg-xwininfo wmctrl

    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

if [ $startStep -lt 2 ]; then
    echo "Installing aur packages ..."
    mkdir -p ~/aur

    cd ~/aur

    git clone https://aur.archlinux.org/ttf-font-awesome-4.git
    cd ttf-font-awesome-4
    makepkg -is
    cd ..
fi

if [ $startStep -lt 3 ]; then
    echo "Copying configs ..."

    configs=`find . -name "_*"`

    for config in $configs
    do
        # ./_vimrc -> _vimrc
        newConfig=`echo $config | sed 's#^\./##'`

        # _vimrc -> .vimrc
        newConfig=`echo $newConfig | sed 's/^_/\./'`

        # copy to home directory
        cp -R $config ~/$newConfig
    done
fi

if [ $startStep -lt 4 ]; then
    echo "Copying scripts ..."
    1&>/dev/null mkdir ~/bin
    cp ./bin/* ~/bin
fi

if [ $startStep -lt 5 ]; then
    echo "Setting up root configs ..."
    sudo mkdir /root
    sudo cp _vimrc /root/.vimrc
fi

if [ $startStep -lt 6 ]; then
    echo "Setting up vim ..."
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    sudo mkdir -p /root/.vim/bundle
    sudo git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
    sudo vim +PluginInstall +qall
fi

if [ $startStep -lt 7 ]; then
    echo "Initializing docker ..."
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
fi

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Done."
exit $exitCode
