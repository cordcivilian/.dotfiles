" .vimrc

set nocompatible
set number
set hidden
set relativenumber
set autoindent
set ruler
set hlsearch
set backspace=indent,eol,start
set shiftwidth=4
set softtabstop=4
set expandtab
set noshowmode
set nowrap
set belloff=all
set scrolloff=8
set signcolumn=yes
set colorcolumn=80

syntax on
colorscheme slate 
highlight ColorColumn ctermbg=238

if $TERM=='screen-256color'
    set ttymouse=xterm2
endif

if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif

if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "", 0700)
endif

if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "", 0700)
endif

if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif

set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set swapfile
set backup
set undofile

autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter,FocusGained * call
            \ system('tmux rename-window ' . expand('%:t'))

autocmd VimLeave * call system('tmux rename-window bash')

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \| PlugInstall --sync | source $MYVIMRC
            \| endif

call plug#begin()
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
    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

let g:lsp_diagnostics_float_cursor = 1

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

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

let NERDTreeShowLineNumbers=1
let g:undotree_SetFocusWhenToggle = 1
autocmd FileType nerdtree setlocal relativenumber
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>g :Git<CR>

command! -bang -nargs=* Rg call fzf#vim#grep(
            \"rg --column --line-number --no-heading --color=always --smart-case "
            \.shellescape(<q-args>), 2, {'options': '--delimiter : --nth 4..'},
            \<bang>0
            \) 
