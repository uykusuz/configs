#!/bin/bash

exitCode=0

echo "Installing base packages ..."

sudo apt-get install vim screen git git-gui

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

echo "Sourcing new bashrc ..."
source ~/.bashrc

echo "Setting up vim ..."
if [ -d "~/.vim/bundle/nerdtree/doc" ]; then
    vim -c "helptags ~/.vim/bundle/nerdtree/doc"
else
    (>&2 echo "Error: NERDTree not found! Skipping initialization of it.")
    exitCode=1
fi

echo "Done."
exit $exitCode
