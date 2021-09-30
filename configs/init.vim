set autoread

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '>'


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.

" let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1

" Disable continuous linting to save CPU cycles

let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_completion_autoimport = 1

let g:ale_go_golangci_lint_executable = 'golangci-lint'

let g:ale_linters = {
\   'go': ['gofmt', 'golint', 'govet', 'gobuild', 'golangci-lint'],
\   'd': ['dls', 'dmd'],
\   'python': ['flake8', 'pylint', 'pyre', 'mypy'],
\   'typescript': ['deno'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'rust': ['rustfmt'],
\   'go': ['gofmt'],
\   'c': ['clang-format', 'clangtidy'],
\   'cpp': ['clang-format', 'clangtidy'],
\   'python': ['black'],
\   'typescript': ['deno'],
\}

let g:vimtex_compiler_method = 'tectonic'

call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

Plug 'JuliaEditorSupport/julia-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'  " Fuzzy finder vim support
Plug 'vim-airline/vim-airline'
Plug 'dense-analysis/ale'
Plug 'flazz/vim-colorschemes'
Plug 'mattn/emmet-vim'
Plug 'earthly/earthly.vim', { 'branch': 'main' }
Plug 'zah/nim.vim'
Plug 'ziglang/zig.vim'
Plug 'preservim/nerdtree'
Plug 'lervag/vimtex'

" Initialize plugin system
call plug#end()

colorscheme github

imap <C-e> <esc>$i<right>
imap <C-a> <esc>0i

" Custom mapping <leader> (see `:h mapleader` for more info)
let mapleader = ','

nnoremap <leader>f :w<C-j>:FZF<C-j>
nnoremap <leader>w :w<C-j>
nnoremap <leader>b :w<C-j>:buffer<space>

" call neomake#configure#automake('w')
" nnoremap <leader>m :Neomake<C-j>
" nmap <silent> <C-k> :lprev<C-j>
" nmap <silent> <C-j> :lnext<C-j>

nnoremap <leader>d :ALEDetail<C-j>
nnoremap <leader>h :ALEHover<C-j>

" set omnifunc=ale#completion#OmniFunc

nn <silent> <M-d> :ALEGoToDefinition<cr>
nn <silent> <M-r> :ALEFindReferences<cr>
nn <silent> <M-a> :ALESymbolSearch<cr>

" navigate between errors with Ctrl-k and Ctrl-j
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

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
