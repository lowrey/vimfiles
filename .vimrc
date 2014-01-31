set nocompatible
set backspace=indent,eol,start
if has('gui_running')
    source $VIMRUNTIME/mswin.vim 
    set sessionoptions+=resize
    " change increment number to num pad plus
    set clipboard=unnamed
    noremap <C-kPlus> <C-A> 
    noremap <C-kMinus> <C-X>
    " colorscheme desert
    set background=dark
    colorscheme solarized
else
    let g:solarized_termcolors = &t_Co
    let g:solarized_termtrans = 1
    colorscheme solarized
endif
set hidden
set history=1000
"Change directory to the dir of the current buffer
noremap \cd :cd %:p:h<CR>

" remap keys
" easy buffer switching
nnoremap <C-n> :bnext<CR> 
nnoremap <C-p> :bprevious<CR>
" Made D behave
" nnoremap D d$
" Keep search matches in the middle of the window and pulse the line when moving
" to them.
nnoremap n nzzzv
nnoremap N Nzzzv
" Don't move on *
nnoremap * *<c-o>
" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

if has("unix")
    cmap w!! w !sudo tee % >/dev/null
    set undofile
    set undodir=~/.vim/tmp/undo//     " undo files
    set backup                        " enable backups
    set backupdir=~/.vim/tmp/backup// " backups
    set noswapfile                    " It's 2012, Vim.
    set directory=~/.vim/tmp/swap//   " swap files
    set undoreload=1000
endif

" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()
"
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
syntax on

set wildmenu " better command autocompletion
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
set showmatch

" searching related
set incsearch
set hlsearch
set smartcase

" When editing a file, always jump to the last cursor position
if has("autocmd") 
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

" To enable the saving and restoring of screen positions.
let g:screen_size_restore_pos = 1

" To save and restore screen for each Vim instance.
" This is useful if you routinely run more than one Vim instance.
" For all Vim to use the same settings, change this to 0.
let g:screen_size_by_vim_instance = 1

" Restore screen size and position
" Saves data in a separate file, and so works with multiple instances of Vim.
if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " - Remembers and restores winposition, columns and lines stored in
    "   a .vimsize file
    " - Must follow font settings so that columns and lines are accurate
    "   based on font size.
    if !has("gui_running")
      return
    endif
    if g:screen_size_restore_pos != 1
      return
    endif
    let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
    " read any existing variables from .vimsize file
    silent! execute "sview " . escape(ScreenFilename(),'%#\ $')
    silent! execute "0/^" . vim_instance . " /"
    let vim_name  = matchstr(getline('.'), '^\w\+')
    let vim_cols  = matchstr(getline('.'), '^\w\+\s\+\zs\d\+')
    let vim_lines = matchstr(getline('.'), '^\w\+\s\+\d\+\s\+\zs\d\+')
    let vim_posx  = matchstr(getline('.'), '^\w\+\s\+\d\+\s\+\d\+\s\+\zs\d\+')
    let vim_posy  = matchstr(getline('.'), '^\w\+\s\+\d\+\s\+\d\+\s\+\d\+\s\+\zs\d\+')
    if vim_name == vim_instance
      execute "set columns=".vim_cols
      execute "set lines=".vim_lines
      silent! execute "winpos ".vim_posx." ".vim_posy
    endif
    silent! q
  endfunction

  function! ScreenSave()
    " used on exit to retain window position and size
    if !has("gui_running")
      return
    endif
    if !g:screen_size_restore_pos
      return
    endif
    let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
    silent! execute "split " . escape(ScreenFilename(),'%#\ $')
    silent! execute "0/^" . vim_instance . " /"
    let vim_name  = matchstr(getline('.'), '^\w\+')
    if vim_name == vim_instance
      delete _
    endif
    $put = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
          \ (getwinposx()<0?0:getwinposx()) . ' ' .
          \ (getwinposy()<0?0:getwinposy())
    silent! x!
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * call ScreenRestore()
  autocmd VimLeavePre * call ScreenSave()
endif
