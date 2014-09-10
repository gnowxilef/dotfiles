" A vimrc file.
"
" Original Author:   Bram Moolenaar <Bram@vim.org>
" Maintainer:        Felix Wong <felix@xilef.org>
" Last change:       2014.09.09
"
"             To use it:  Copy it to
"             for Amiga:  s:.vimrc
"           for OpenVMS:  sys$login:.vimrc
"     for *nix and OS/2:  ~/.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

if &term=="xterm" || &term=="xterm-color" || &term=="xterm-256color"
  set t_Co=8
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  :imap <Esc>Oq 1
  :imap <Esc>Or 2
  :imap <Esc>Os 3
  :imap <Esc>Ot 4
  :imap <Esc>Ou 5
  :imap <Esc>Ov 6
  :imap <Esc>Ow 7
  :imap <Esc>Ox 8
  :imap <Esc>Oy 9
  :imap <Esc>Op 0
  :imap <Esc>On .
  :imap <Esc>OQ /
  :imap <Esc>OR *
  :imap <Esc>Ol +
  :imap <Esc>OS -
endif

let mapleader = ","
set showtabline=2

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"  set nobackup         " do not keep a backup file, use versions instead
"else
"  set backup           " keep a backup file
"endif

set history=20          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Always display the status line, even if only one window is displayed
set laststatus=2

" Better command-line completion
set wildmode=longest,list,full
set wildmenu

set switchbuf=useopen
set winwidth=80

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 79 characters.
    autocmd FileType text setlocal textwidth=79
    set textwidth=79
    if exists('+colorcolumn')
      set colorcolumn=+1        " highlight column after 'textwidth'
    else
      au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
    endif
    highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

  augroup END

  " Convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.
  " Only define it when not defined already.
  if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
  endif

  " Alias :WQ to save with sudo
  cnoremap WQ w !sudo tee % > /dev/null
  set number
  set ic
  set expandtab
  set tabstop=4
  set shiftwidth=4
  set smartindent
  set cursorline
  set encoding=utf-8

  set foldmethod=marker
  set foldenable
  set ls=2
  "augroup vimrc
  "  au BufReadPre * setlocal foldmethod=indent
  "  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
  "augroup END
  "let g:detectindent_preferred_expandtab = 1
  "let g:detectindent_preferred_indent = 4
  "let g:detectindent_max_lines_to_analyse = 1024
  cmap sp set paste
  cmap sn set nopaste
  cmap cel colorscheme elflord
  cmap stw set textwidth=999999

  " Instead of failing a command because of unsaved changes, instead raise a
  " dialogue asking if you wish to save changed files.
  set confirm

  " Remove byte order mark
  set nobomb

else

  set autoindent                " always set autoindenting on

endif " has("autocmd")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

call pathogen#infect()