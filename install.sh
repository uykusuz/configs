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

sudo apt-get install vim screen git git-gui tmux

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
1&>/dev/null mkdir ~/bin
cp ./bin/* ~/bin

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Setting up awesome ..."
mkdir -p ~/.config
cp -r awesome ~/.config/

echo "Setting up vim ..."
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Initializing Vim's YouCompleteMe ..."
sudo apt-get install build-essential cmake python-dev python3-dev
pushd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer
popd

echo "Installing touchpad configuration ..."
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 50-synaptics.conf /etc/X11/xorg.conf.d/

echo "Done. Restart X server to activate the touchpad configuration."
exit $exitCode
