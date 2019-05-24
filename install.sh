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
nextStep=1

if [ $startStep -lt $nextStep ]; then
    echo "Installing base packages ..."

    sudo pacman -S vim git tk gitg aspell-en tmux maven docker python

    # i3
    sudo pacman -S i3 dmenu acpi
    mkdir -p ~/.config
    git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks
    # for i3blocks' arch-udpate
    sudo pacman -S pacman-contrib

    # dependencies for switch-monitor
    sudo pacman -S xorg-xrandr xdotool xorg-xprop xorg-xwininfo wmctrl

    if [ $? -ne 0 ]; then
        exit 1
    fi

    # python stuff
    sudo easy_install pip
    sudo pip install virtualenv
fi

nextStep+=1

if [ $startStep -lt $nextStep ]; then
    echo "Installing aur packages ..."
    mkdir -p ~/aur

    pushd ~/aur

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -is

    popd

    yay ttf-font-awesome-4
fi

nextStep+=1

if [ $startStep -lt $nextStep ]; then
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

nextStep+=1

if [ $startStep -lt $nextStep ]; then
    echo "Copying scripts ..."
    1&>/dev/null mkdir ~/bin
    cp ./bin/* ~/bin
fi

nextStep+=1

if [ $startStep -lt $nextStep ]; then
    echo "Setting up root configs ..."
    sudo mkdir /root
    sudo cp _vimrc /root/.vimrc
fi

nextStep+=1

if [ $startStep -lt $nextStep ]; then
    echo "Setting up vim ..."
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    sudo mkdir -p /root/.vim/bundle
    sudo git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
    sudo vim +PluginInstall +qall
fi

nextStep+=1

if [ $startStep -lt $nextStep ]; then
    echo "Initializing docker ..."
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
fi

nextStep+=1

if [ $startStep -lt $nextStep ]; then
    sudo pacman -S zsh
    yay oh-my-zsh-git powerline-fonts-git
    chsh -s /bin/zsh
fi

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Done."
exit $exitCode
