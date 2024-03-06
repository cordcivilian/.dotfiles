" init.vim

set nocompatible

let NVIM_DIR = $HOME . "/.config/nvim"
let BACKUP_DIR = $HOME . "/.config/nvim/backup"
let SWAP_DIR = $HOME . "/.config/nvim/swap"
let UNDO_DIR = $HOME . "/.config/nvim/undo"
if !isdirectory(NVIM_DIR) | call mkdir(NVIM_DIR, "", 0770) | endif
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
set noruler
set noshowmode
set laststatus=0

set expandtab
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start

set autoindent
set clipboard+=unnamedplus  "requirement: xclip

set hidden
set nowrap
set hlsearch
set belloff=all
set signcolumn=yes
set colorcolumn=80
set scrolloff=16

syntax on
colorscheme slate 
highlight ColorColumn ctermbg=238
highlight Pmenu ctermfg=White ctermbg=238 cterm=None
highlight FloatBorder ctermfg=White ctermbg=238 cterm=NONE

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <S-g> <S-g>zz
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

let DATA_DIR = $HOME . "/.local/share/nvim/site"
if empty(glob(DATA_DIR. '/autoload/plug.vim'))
  silent execute '!curl -fLo '.DATA_DIR.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif

call plug#begin()  " $HOME/.local/share/nvim/plugged
    Plug 'sheerun/vim-polyglot'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-fugitive'
call plug#end()

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
    let g:lsp_diagnostics_virtual_text_enabled = 0
    let g:lsp_format_sync_timeout = 500
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_float_cursor = 1
let g:lsp_settings_filetype_python = 'pylsp-all'

let NERDTreeShowLineNumbers=1
let g:undotree_SetFocusWhenToggle = 1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd FileType nerdtree setlocal relativenumber
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 2, {'options': '--delimiter : --nth 4..'},<bang>0)

nnoremap <leader>g :Git<CR>

autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter,FocusGained * call system('tmux rename-window ' . expand('%:t'))
autocmd VimLeave * silent call jobstart(system('tmux rename-window bash'), {'detach': 1})
