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

    sudo pacman -S vim git tk gitg aspell-en tmux fish

    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

if [ $startStep -lt 2 ]; then
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

if [ $startStep -lt 3 ]; then
    echo "Copying scripts ..."
    1&>/dev/null mkdir ~/bin
    cp ./bin/* ~/bin
fi

if [ $startStep -lt 4 ]; then
    echo "Setting up root configs ..."
    sudo mkdir /root
    sudo cp _vimrc /root/.vimrc
fi

if [ $startStep -lt 5 ]; then
    echo "Setting up vim ..."
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    sudo mkdir -p /root/.vim/bundle
    sudo git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
    sudo vim +PluginInstall +qall
fi

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Done."
exit $exitCode
