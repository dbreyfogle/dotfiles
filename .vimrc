" Set leader
let mapleader=" "

" Map kj to Escape
inoremap kj <Esc>

" Use J and K to move faster
noremap J 5j
noremap K 5k

" Join line
noremap <Leader>J J

" Map H and L to beginning/end of line
noremap H ^
noremap L $

" Map Y to act like D and C
noremap Y y$

" Center the cursor vertically when moving to the next word during a search
noremap n nzz
noremap N Nzz

" Clear search highlights with Enter
noremap <silent> <Enter> :noh<CR>

" Managing panes
noremap <Leader>- :sp<CR>
noremap <Leader>\ :vsp<CR>
noremap <Leader>x <C-W>c
noremap <Leader>j <C-W>j
noremap <Leader>k <C-W>k
noremap <Leader>h <C-W>h
noremap <Leader>l <C-W>l

" Managing tabs
noremap <Leader>c :tabnew<CR>
noremap <Leader>& :tabclose<CR>
noremap <Leader>p :tabprev<CR>
noremap <Leader>n :tabnext<CR>
noremap <Leader>< :tabmove -1<CR>
noremap <Leader>> :tabmove +1<CR>

" Use system clipboard by default
" set clipboard=unnamed     " macOS / Windows
set clipboard=unnamedplus " Linux / WSL

" Hide status bar
set laststatus=0

" Better command-line completion
set wildmenu
set wildmode=list:longest,full

" Set utf8 as default encoding
set encoding=utf8

" Enable mouse
set mouse=a

" Indentation settings
set list
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" Do not let cursor scroll above or below N lines
set scrolloff=10

" Display relative line numbers
set number
set relativenumber

" Do not wrap lines
set nowrap

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Highlight searches
set incsearch
set hlsearch

" Automatically focus new splits
set splitbelow
set splitright

" Turn backup off
set nobackup
set noswapfile
set nowb

" Disable annoying sounds on errors
set noerrorbells
set novisualbell

" Enable 24 bit colors
if has("termguicolors")
  set termguicolors
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugins
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'joshdick/onedark.vim'
call plug#end()

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

colorscheme onedark
