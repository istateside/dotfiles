#!/bin/bash

fullpath=$(realpath $0)
DIR=$(dirname $fullpath)

### BASH SETUP
bash_source="source $DIR/bashrc"
bash_original="$HOME/.bashrc"

if [ ! -f "$bash_original" ]; then
  touch "$bash_original"
  echo "Created $bash_original file"
fi

if ! grep --quiet "$bash_source" $bash_original; then
  echo "Appending the following to "$bash_original" :"
  echo -e "$bash_source"
  echo -e "\n$bash_source" >> $bash_original
else
  echo "Already found correct source line in $bash_original"
fi

### VIM SETUP
vim_original="$HOME/.vimrc"
vim_source="source $DIR/vimrc"

if ! command -v vim >/dev/null; then
  echo "WARNING: Could not find an installation for vim on this system."
fi

if [ ! -f "$vim_original" ]; then
  touch $vim_original
  echo "Created $vim_original file"
fi

if ! grep --quiet "$vim_source" $vim_original; then
  echo "Appending the following to $vim_original :"
  echo -e "$vim_source"
  echo -e "\n$vim_source" >> $vim_original
else
  echo "Already found correct source line in $vim_original"
fi

### TMUX SETUP
tmux_original="$HOME/.tmux.conf"
tmux_source="source $DIR/.tmux.conf"

if ! command -v tmux >/dev/null; then
  echo "WARNING: Could not find an installation for tmux on this system."
fi

if [ ! -f "$tmux_original" ]; then
  touch $tmux_original
  echo "Created $tmux_original file"
fi

if ! grep --quiet "$tmux_source" $tmux_original; then
  echo "Appending the following to $tmux_original :"
  echo -e "$tmux_source"
  echo -e "\n$tmux_source" >> $tmux_original
else
  echo "Already found correct source line in $tmux_original"
fi

echo "Completed setup."
