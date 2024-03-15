" .vimrc

set nocompatible

let VIM_DIR = $HOME . "/.vim"
let BACKUP_DIR = $HOME . "/.vim/backup"
let SWAP_DIR = $HOME . "/.vim/swap"
let UNDO_DIR = $HOME . "/.vim/undo"
if !isdirectory(VIM_DIR) | call mkdir(VIM_DIR, "", 0770) | endif
if !isdirectory(SWAP_DIR) | call mkdir(SWAP_DIR, "", 0700) | endif
if !isdirectory(UNDO_DIR) | call mkdir(UNDO_DIR, "", 0700) | endif
if !isdirectory(BACKUP_DIR) | call mkdir(BACKUP_DIR, "", 0700) | endif
execute "set directory=" . SWAP_DIR . "//"
execute "set undodir=" . UNDO_DIR . "//"
execute "set backupdir=" . BACKUP_DIR . "//"
set swapfile
set undofile
set backup

set number
set relativenumber

set expandtab
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start

set autoindent

set hidden
set nowrap
set hlsearch
set belloff=all
set signcolumn=yes
set colorcolumn=80
set scrolloff=8

syntax on
colorscheme slate
highlight ColorColumn ctermbg=238

if $TERM=='screen-256color' | set ttymouse=xterm2 | endif

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

vnoremap <leader>d "_d
nnoremap <leader>d "_d
vnoremap <leader>y "+y
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
nnoremap <leader>Y "+Y
vnoremap <leader>p "+p
nnoremap <leader>p "+p

nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <silent> <leader>x <cmd>!chmod +x %<CR>

if empty(glob(VIM_DIR . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.VIM_DIR.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif

call plug#begin()
    Plug 'sheerun/vim-polyglot'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'dense-analysis/ale'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-fugitive'
    Plug 'markonm/traces.vim'
call plug#end()

filetype plugin on
set statusline+=%{gutentags#statusline()}
set omnifunc=syntaxcomplete#Complete
autocmd CompleteDone * pclose

let g:ale_linters = {'python': ['ruff']}
let g:ale_fixers = {'python': ['ruff']}
nmap <silent> [g :ALENext<CR>
nmap <silent> ]g :ALEPrevious<CR>
highlight link ALEVirtualTextError Error

let NERDTreeShowLineNumbers = 1
let g:undotree_SetFocusWhenToggle = 1
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd FileType nerdtree setlocal relativenumber
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 2, {'options': '--delimiter : --nth 4..'},<bang>0)

nnoremap <leader>g :Git<CR>

autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter,FocusGained * call system('tmux rename-window ' . expand('%:t'))
autocmd VimLeave * silent call system('tmux rename-window bash')
