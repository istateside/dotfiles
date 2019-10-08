call plug#begin('~/.vim/plugged')
  Plug 'flazz/vim-colorschemes' " color schemes
  Plug 'scrooloose/nerdtree' " file explorer
  Plug 'scrooloose/nerdcommenter' " commenting tools
  Plug 'qpkorr/vim-bufkill' " dont close splits when deleting buffer
  Plug 'w0rp/ale' " linter and fixer
  Plug 'tpope/vim-fugitive' " git integration commands
  Plug 'airblade/vim-gitgutter' " git integration in left column
  Plug 'itchyny/lightline.vim' " more helpful status line
  Plug 'ap/vim-buftabline' " show open buffers in tabline
  Plug 'sheerun/vim-polyglot' " language packs
  Plug 'pangloss/vim-javascript' " better js language pack
  Plug 'mustache/vim-mustache-handlebars' " better hbs syntax highlighting
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " language server integration

  if has('nvim')
    " nvim specific plugins
    Plug 'Shougo/denite.nvim'
  else
    " vim specific plugins
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
  endif
call plug#end()

source ~/.dotfiles/simple-vimrc

" Plugin settings
colorscheme gruvbox " colorscheme, installed from the vim-colorschemes plugin

" nerdcommenter mappings
let g:NERDSpaceDelims = 1
nnoremap <leader>c<space> :call NERDComment("n", "Toggle")<CR>
vnoremap <leader>c<space> :call NERDComment("n", "Toggle")<CR>gv

"coc settings
nmap <silent> <C-l>d <Plug>(coc-definition)
nmap <silent> <C-l>t <Plug>(coc-type-definition)
nmap <silent> <C-l>s <Plug>(coc-references)
nmap <silent> <C-l>r <Plug>(coc-rename)
nmap <silent> <C-l>k :call <SID>show_documentation()<CR>
nmap <silent> <leader>r :CocCommand tsserver.restart<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd BufEnter,BufRead,BufNewFile *.buildconfig :setlocal filetype=json
autocmd BufEnter,BufRead,BufNewFile *.buildconfig :setlocal syntax=json
autocmd BufEnter,BufRead,BufNewFile *.jsont :setlocal filetype=html
autocmd BufEnter,BufRead,BufNewFile *.jsont :setlocal syntax=html
autocmd BufEnter,BufRead,BufNewFile *.less.hbs :setlocal syntax=less.handlebars
autocmd BufEnter,BufRead,BufNewFile *.less.hbs :setlocal filetype=less.handlebars

"map Control+N to open NERDTree
map <C-n> :NERDTreeToggle<CR>
map <C-h> :NERDTreeFind<CR>
let g:NERDTreeWinSize=40 
let g:NERDTreeShowHidden=1
let NERDTreeHijackNetrw=1

" linting for js
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \ 'javascript': ['eslint']
      \ }

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
  source ~/.dotfiles/denite-settings.vim
else
  nnoremap <leader>f :Files<CR>
endif
