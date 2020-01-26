if [ -f ~/.bashrc ]
then
else
  touch ~/.bashrc
fi

if [ -f ~/.vimrc ]
then
else
  touch ~/.vimrc
fi

if [ -f ~/.tmux.conf ]
then
else
  touch ~/.tmux.conf
fi

if grep -q "source ~/dotfiles/bashrc" "~/.bashrc"; then
  Some Actions # SomeString was found
fi
