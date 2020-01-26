" Denite setup Pulled from https://github.com/ctaylo21/jarvis/blob/master/config/nvim/init.vim#L58
call denite#custom#var('file/rec', 'command', ['rg', '--hidden', '--files', '--glob', '!.git'])
call denite#custom#source('file/rec', 'sorters', ['sorter/sublime'])
call denite#custom#alias('source', 'file/rec/build', 'file/rec')
call denite#custom#var('file/rec/build', 'command', ['rg', '--hidden', '--files', '--no-ignore-vcs', '--glob', '!.git', ':directory', 'build/'])

call denite#custom#var('grep', 'command', ['rg'])
" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])"
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>f     - Fuzzy find list of files in current directory
"   <leader>b     - Fuzzy find list of files in current directory, ignoring .gitignore file
"   <leader>g     - Search current directory for occurences of word under cursor
"   <leader>a     - Search current directory for occurences of given term and close window if no results
nmap ; :Denite buffer<CR>
nmap <leader>f :DeniteProjectDir file/rec<CR>
nmap <leader>b :DeniteProjectDir file/rec/build<CR>
nnoremap <leader>g :<C-u>DeniteCursorWord grep:.<CR>
nnoremap <leader>a :<C-u>Denite grep:. -no-empty<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select')
endfunction

let s:denite_options = {'default' : {
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ:',
\ 'statusline': 0,
\ 'highlight_matched_char': 'WildMenu',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'StatusLine',
\ 'highlight_prompt': 'StatusLine',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

call s:profile(s:denite_options)
