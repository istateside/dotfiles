alias nv="nvim"
alias vimrc="nvim ~/.vimrc"
alias bashrc="nvim ~/.bashrc"
alias vimpack="cd ~/.vim/pack/default/start"
alias vimplug="nvim ~/.local/share/nvim/site/autoload/plug.vim"
alias ag="ag --path-to-ignore ~/.agignore"

source ./git-completion.bash

__complete_goto() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  local dirs="$(ls ~/projects/)"
  COMPREPLY=($(compgen -W "$dirs" -- "${COMP_WORDS[1]}"))
}

goto() {
  cd ~/projects/$1
}

complete -F __complete_goto goto

vimdiff() {
  nvim `git status --porcelain | sed -ne 's/^UU //p'`
}

RED='\[\033[38;5;9m\]'
YELLOW='\[\033[38;5;11m\]'
GREEN='\[\033[38;5;10m\]'
BLUE='\[\033[38;5;6m\]'
RESET="\[$(tput sgr0)\]"

PS1="${RED}\u${YELLOW}@${GREEN}\w${BLUE}\[\$(__git_ps1)\] \$\[$(tput sgr0)\] "
