#!/bin/bash

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

echo "Done."
