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

echo "Installing base packages ..."

sudo pacman -S vim git gitg tmux kdiff3

if [ $? -ne 0 ]; then
    exit 1
fi

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

echo "Copying scripts ..."
1&>/dev/null mkdir -p ~/bin
cp ./bin/* ~/bin

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Setting up vim ..."
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Setting up root configs ..."
sudo cp _vimrc /root/.vimrc

echo "Installing touchpad configuration ..."
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 50-synaptics.conf /etc/X11/xorg.conf.d/

echo "Done. Restart X server to activate the touchpad configuration."
exit $exitCode
