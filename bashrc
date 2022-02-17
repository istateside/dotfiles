alias nv="nvim"
alias gi="git"
alias gitt="git"
alias gittt="git"
alias vimrc="nvim ~/dotfiles/vimrc"
alias bashrc="nvim ~/dotfiles/bashrc"
alias zshrc="nvim ~/.zshrc"
alias vimpack="cd ~/.vim/pack/default/start"
alias vimplug="nvim ~/.local/share/nvim/site/autoload/plug.vim"
alias ag="ag --path-to-ignore ~/.agignore"

# source ~/dotfiles/git-completion.bash

# __complete_goto() {
#   if [ "${#COMP_WORDS[@]}" != "2" ]; then
#     return
#   fi

#   local dirs="$(ls ~/projects/)"
#   COMPREPLY=($(compgen -W "$dirs" -- "${COMP_WORDS[1]}"))
# }

# complete -F __complete_goto goto

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export TERM=xterm-256color

vimdiff() {
  nvim `git status --porcelain | sed -ne 's/^UU //p'`
}

diffs() {
  open ~/projects/squarespace-v6/site-server/src/test/charcoal/screens/{latest,stable,diffs}/qa/chrome/en-US/$1/development/*
}

tokens() {
  nvim ~/projects/core-components/packages/tokens/less.less
}

export BROWSERSLIST_ENV=modern
export ANSIBLE_VAULT_PASSWORD_FILE=$HOME/.ansible-vault-pw

saveScripts() {
  branchName=`git branch --show-current`
  echo "Caching built files for current branch branch $branchName..."
  safeBranchName="${branchName//\//_}"

  mkdir -p ~/saved-ss-bundles/$safeBranchName
  universalDir=/Users/kfleischman/projects/squarespace-v6/site-server/src/main/webapp/universal

  tar -czf ~/saved-ss-bundles/$safeBranchName/archive.tar.gz $universalDir/scripts-compressed $universalDir/styles-compressed
  echo "Done - cache built for $safeBranchName. Run \`loadScripts\` while on this branch to restore them later."
}

loadScripts() {
  branchName=`git branch --show-current`
  echo "Loading built files from cache for current branch $branchName..."

  safeBranchName="${branchName//\//_}"

  universalDir=/Users/kfleischman/projects/squarespace-v6/site-server/src/main/webapp/universal

  tar -xf ~/saved-ss-bundles/$safeBranchName/archive.tar.gz

  echo "Built files restored from cache."
}

sha() {
  shaHash=`git rev-parse HEAD`
  echo $shaHash | tr -d "\n" | pbcopy
  echo $shaHash
}

PATH=$PATH:/Users/kfleischman/projects/kubectl-plugins
