#!/bin/bash

fullpath=$(realpath $0)
DIR=$(dirname $fullpath)

touch ~/.bashrc
echo "Appending the following to ~/.bashrc :"
echo -e "source $DIR/bashrc"
echo -e "source $DIR/bashrc" >> ~/.bashrc

touch ~/.vimrc
echo "Appending the following to ~/.vimrc :"
echo -e "source $DIR/vimrc"
echo -e "source $DIR/vimrc" >> ~/.vimrc

touch ~/.tmux.conf
echo "Appending the following to ~/.tmux.conf :"
echo -e "source $DIR/.tmux.conf"
echo -e "source $DIR/.tmux.conf" >> ~/.tmux.conf
