" autocmd BufRead,BufWrite *.go silent! !gofmt -w <afile> && gci -w <afile>
" autocmd BufRead,BufWrite *.go !gofmt <abuf> && gci <abuf>

function! FormatReload(cmd)
     :w
     :call Format(a:cmd)
     :e! <afile>
endfunction

function! Format(cmd)
    let save_pos = getpos('.')
    execute('silent! ' . a:cmd)
    call setpos(".", save_pos)
endfunction

autocmd BufRead,BufWrite *.go :call FormatReload("!gofmt -w <afile>")
" autocmd BufRead,BufWrite *.go :call FormatReload("!gci -w <afile>")

" autocmd BufRead,BufWrite *.rs :call Format("%!rustfmt")
autocmd BufRead,BufWrite *.rs :call Format("!rustfmt --emit files <afile>")

" autocmd BufRead,BufWrite *.rs %!rustfmt
set autoread

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')


" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.

" Make sure you use single quotes
"
let g:neomake_open_list = 2
let g:neomake_c_enabled_makers = ['clangtidy']
let g:neomake_cpp_enabled_makers = ['clangtidy']

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

Plug 'vim-airline/vim-airline'
" Plug 'dense-analysis/ale'
Plug 'flazz/vim-colorschemes'
Plug 'mattn/emmet-vim'
Plug 'earthly/earthly.vim', { 'branch': 'main' }
Plug 'zah/nim.vim'
Plug 'ziglang/zig.vim'
Plug 'neomake/neomake'

" Initialize plugin system
call plug#end()

colorscheme github

imap <C-e> <esc>$i<right>
imap <C-a> <esc>0i

" Custom mapping <leader> (see `:h mapleader` for more info)
let mapleader = ','
call neomake#configure#automake('w')

nnoremap <leader>w :w<C-j>
nnoremap <leader>b :w<C-j>:buffer<space>
nnoremap <leader>m :Neomake<C-j>

" navigate between errors with Ctrl-k and Ctrl-j
nmap <silent> <C-k> :lprev<C-j>
nmap <silent> <C-j> :lnext<C-j>

let g:user_emmet_leader_key=','

"{ UI-related settings
"{{ General settings about colors
" Enable true colors support. Do not set this option if your terminal does not
" support true colors! For a comprehensive list of terminals supporting true
" colors, see https://github.com/termstandard/colors and
" https://gist.github.com/XVilka/8346728.
if match($TERM, '^xterm.*') != -1 || exists('g:started_by_firenvim')
  set termguicolors
endif

" Disable creating swapfiles, see https://stackoverflow.com/q/821902/6064933
set noswapfile

" Highlight long lines
set colorcolumn=79

" General tab settings
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

set number relativenumber  " Show line number and relative line number

" Ignore case in general, but become case-sensitive when uppercase is present
set ignorecase smartcase

" File and script encoding settings for vim
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" Break line at predefined characters
set linebreak

" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3

set fileformats=unix,dos  " Fileformats to use for new files

function CallBuild()
    ! gotoolbox task build
endfunction

" Build commands
command! -bar Build :call CallBuild()

" Ignore certain files and folders when globbing
set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
set wildignore+=*.pyc
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz
set wildignorecase  " ignore file and dir name cases in cmd-completion

" Ask for confirmation when handling unsaved or read-only files
set confirm

set visualbell noerrorbells  " Do not use visual and errorbells
set history=500  " The number of command and search history to keep
