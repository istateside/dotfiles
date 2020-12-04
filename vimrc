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
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ap/vim-buftabline' " show open buffers in tabline
  Plug 'tpope/vim-rhubarb' " vim-fugitive support for github links
  Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'

  if has('nvim')
    " nvim specific plugins
    Plug 'Shougo/denite.nvim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " language server integration
  endif
call plug#end()

source ~/dotfiles/simple-vimrc

" Plugin settings
colorscheme gruvbox " colorscheme, installed from the vim-colorschemes plugin

" nerdcommenter mappings
let g:NERDDefaultAlign = 'left'
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
autocmd BufEnter,BufRead,BufNewFile *.list :setlocal filetype=html
autocmd BufEnter,BufRead,BufNewFile *.list :setlocal syntax=html
autocmd BufEnter,BufRead,BufNewFile *.block :setlocal filetype=html
autocmd BufEnter,BufRead,BufNewFile *.block :setlocal syntax=html
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
  let package_file = findfile('package.json', '.;.git;')

  if len(package_file)
    execute 'pedit' package_file
    :wincmd P
    return
  end

  echo "'package.json' file could not be found"
endfunction

map <leader>o :call OpenDirInFinder()<CR>
function! OpenDirInFinder()
  :!open %:p:h
endfunction

" vim-bufkill bindings
let g:BufKillCreateMappings = 0

set previewheight=30
nnoremap <leader>q :bd!<CR>
nnoremap <leader>Q :BD!<CR>

" easy vim reloading`
nnoremap <leader>VR :source ~/.vimrc<CR>:echom "~/.vimrc reloaded!"<CR>

" scratch.vim settings
let g:scratch_persistence_file='~/.vim-scratch-file'
let g:scratch_insert_autohide=0
let g:scratch_no_mappings=1
nnoremap <silent> <plug>(scratch-open) :call scratch#open(0)<cr>
nmap gs <plug>(scratch-open)
nmap gi <plug>(scratch-insert-reuse)

" stop unzooming the vim tmux pane when navigating past edge - for vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed=1

" set python version to 3
set pyxversion=3

" fzf.vim
nnoremap ; :Buffers<CR>
nnoremap <leader>f :Files<CR>
let preview_options = {'options': '--delimiter : --nth 2..'}
command! -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview(preview_options), <bang>0)
nnoremap <leader>a :RG<CR>
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
