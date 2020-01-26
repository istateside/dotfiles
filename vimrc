" Auto install vim-plug if it doesnt exist yet
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'flazz/vim-colorschemes' " color schemes
  Plug 'scrooloose/nerdtree' " file explorer
  Plug 'scrooloose/nerdcommenter' " commenting tools
  Plug 'qpkorr/vim-bufkill' " dont close splits when deleting buffer
  Plug 'tpope/vim-fugitive' " git integration commands
  Plug 'airblade/vim-gitgutter' " git integration in left column
  Plug 'itchyny/lightline.vim' " more helpful status line
  Plug 'sheerun/vim-polyglot' " language packs
  Plug 'pangloss/vim-javascript' " better js language pack
  Plug 'mustache/vim-mustache-handlebars' " better hbs syntax highlighting
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " language server integration
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ap/vim-buftabline' " show open buffers in tabline
  Plug 'mtth/scratch.vim'

  if has('nvim')
    " nvim specific plugins
    Plug 'Shougo/denite.nvim'
  else
    " vim specific plugins
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
  endif
call plug#end()

source ~/dotfiles/simple-vimrc

" Plugin settings
colorscheme gruvbox " colorscheme, installed from the vim-colorschemes plugin

" nerdcommenter mappings
let g:NERDSpaceDelims = 1
nnoremap <leader>c<space> :call NERDComment("n", "Toggle")<CR>
vnoremap <leader>c<space> :call NERDComment("n", "Toggle")<CR>gv

" Code folding
set foldmethod=syntax

"coc settings
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>s <Plug>(coc-references)
nmap <silent> <leader>r <Plug>(coc-rename)
nmap <silent> <leader>R :CocCommand tsserver.restart<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

autocmd BufEnter,BufRead,BufNewFile *.buildconfig :setlocal syntax=json
autocmd BufEnter,BufRead,BufNewFile *.jsont :setlocal filetype=html
autocmd BufEnter,BufRead,BufNewFile *.jsont :setlocal syntax=html
autocmd BufEnter,BufRead,BufNewFile *.less.hbs :setlocal syntax=less.handlebars
autocmd BufEnter,BufRead,BufNewFile *.less.hbs :setlocal filetype=less.handlebars
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

"map leader N to open NERDTree
map <leader>n :NERDTreeToggle<CR>
map <leader>N :NERDTreeFind<CR>

let g:NERDTreeWinSize=40 
let g:NERDTreeShowHidden=1
let NERDTreeHijackNetrw=1

" linting for js
" let g:ale_fix_on_save = 1
" let g:ale_fixers = {
      " \ }

" lightline configuration
set noshowmode " lightline shows mode for us, so this is unneeded

let g:lightline = {
    \ 'active' : {
    \   'left' : [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'relativepath', 'modified'] ],
    \   'right' : [ [ 'filetype' ] ] },
    \ 'inactive' : {
    \   'left' : [ [ 'filename', 'modified' ] ],
    \   'right' : [ [ 'lineinfo' ] ] },
    \ }

if has('nvim')
  let g:gitgutter_highlight_linenrs=1

  source ~/dotfiles/denite-settings.vim
else
  nnoremap <leader>f :Files<CR>
endif

" Open closest package json - useful in a JS monorepo
map <leader>p :call OpenClosestPackageJson()<CR>
function! OpenClosestPackageJson()
ruby <<EOF
  directory_parts = File.dirname($curbuf.name).split("/")

  while (directory_parts.length) do
    filename = [*directory_parts, "package.json"].join("/")
    if File.exist? filename
      Vim::command("edit #{filename}")
      break
    end

    directory_parts.pop()
  end
EOF
endfunction

" vim-bufkill bindings
let g:BufKillCreateMappings = 0
nnoremap <leader>q :BD<CR>

" scratch.vim settings
let g:scratch_persistence_file='~/.vim-scratch-file'
let g:scratch_insert_autohide=0
let g:scratch_no_mappings=1
nnoremap <silent> <plug>(scratch-open) :call scratch#open(0)<cr>
nmap gs <plug>(scratch-open)
nmap gi <plug>(scratch-insert-reuse)
