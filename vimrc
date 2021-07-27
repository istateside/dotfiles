" Auto install vim-plug if it doesnt exist yet
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'airblade/vim-gitgutter' " git integration in left column
  Plug 'ap/vim-buftabline' " show open buffers in tabline
  Plug 'itchyny/lightline.vim' " more helpful status line
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'

  " utilities
  Plug 'qpkorr/vim-bufkill' " dont close splits when deleting buffer
  Plug 'scrooloose/nerdcommenter' " commenting tools

  " Syntax and color
  Plug 'flazz/vim-colorschemes' " color schemes
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'kevinoid/vim-jsonc'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'mtdl9/vim-log-highlighting'
  Plug 'mustache/vim-mustache-handlebars' " better hbs syntax highlighting
  Plug 'pangloss/vim-javascript' " better js language pack
  Plug 'sheerun/vim-polyglot' " language packs

  Plug 'tommcdo/vim-fubitive' "fugitive support for bitbucket
  Plug 'tpope/vim-fugitive' " git integration commands
  Plug 'tpope/vim-rhubarb' " vim-fugitive support for github links


  if has('nvim')
    " nvim specific plugins
    " Plug 'neoclide/coc.nvim', {'branch': 'release'} " language server integration
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    " Plug 'nvim-telescope/telescope.nvim'

    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'

    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'

    Plug 'mattn/efm-langserver'
  else
    " File trees
    Plug 'scrooloose/nerdtree' " file explorer
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

" lightline configuration
set noshowmode " lightline shows mode for us, so this is unneeded

let g:lightline = {
    \ 'active' : {
    \   'left' : [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'absolutepath', 'modified'] ],
    \   'right' : [ [ 'filetype' ] ] },
    \ 'inactive' : {
    \   'left' : [ [ 'filename', 'modified' ] ],
    \   'right' : [ [ 'lineinfo' ] ] },
    \ }

" NEOVIM NVIM settings
if has('nvim')
  let g:gitgutter_highlight_linenrs=1

  " TELESCOPE FUZZY FINDER SETTINGS
  " Find files using Telescope command-line sugar.
  " Using Lua functions
lua << EOF
--[[
  local actions = require('telescope.actions')
  require('telescope').setup{
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        }
      }
    },
  }
]]
EOF
  
  " nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  " nnoremap <leader>fa <cmd>lua require('telescope.builtin').live_grep()<cr>
  " nnoremap <leader>f; <cmd>lua require('telescope.builtin').buffers()<cr>
  " nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

lua << EOF
EOF
  lua require('lsp')
  lua require('nvim-tree-config')
else 
  """"""""""""
  " NERDTREE SETTINGS
  """"""""""""
  nnoremap <leader>n :NERDTreeToggle<CR>
  nnoremap <leader>N :NERDTreeFind<CR>G
  let g:NERDTreeWinSize=40 
  let g:NERDTreeShowHidden=1
  let NERDTreeHijackNetrw=1
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

" stop unzooming the vim tmux pane when navigating past edge - for vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed=1

" set python version to 3
set pyxversion=3

" configure bitbucket for code.squarespace.net
let g:fubitive_domain_pattern = 'code\.squarespace\.net'

" fzf.vim
let preview_options = {'options': '--delimiter : --nth 2..'}
command! -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview(preview_options), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

nnoremap ; :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>a :RG<CR>
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
