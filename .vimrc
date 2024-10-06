" Set leader
let mapleader=" "

" Easier Escape
inoremap kj <Esc>

" Map H and L to beginning/end of line
noremap H ^
noremap L $

" Use J and K to move faster
noremap J 5j
noremap K 5k

" Join line
noremap <Leader>J J

" Map Y to act like D and C
noremap Y y$

" Undo and redo on same key
nnoremap U <C-r>

" Center the cursor when navigating during a search
noremap n nzz
noremap N Nzz

" Clear search highlights with Enter
noremap <silent> <Enter> :noh<CR>

" Pane management
noremap <Leader>- :sp<CR>
noremap <Leader>\ :vsp<CR>
noremap <Leader>x <C-W>c
noremap <Leader>j <C-W>j
noremap <Leader>k <C-W>k
noremap <Leader>h <C-W>h
noremap <Leader>l <C-W>l

" Tab management
noremap <Leader>c :tabnew<CR>
noremap <Leader>& :tabclose<CR>
noremap <Leader>p :tabprev<CR>
noremap <Leader>n :tabnext<CR>
noremap <Leader>< :tabmove -1<CR>
noremap <Leader>> :tabmove +1<CR>

" Use system clipboard by default
" set clipboard=unnamed " for +clipboard
set clipboard=unnamedplus " for +xterm_clipboard

" Indentation settings
set tabstop=4
set shiftwidth=0 " follow tabstop
set softtabstop=-1 " follow shiftwidth
set autoindent
set list

" Display line numbers
set number
set relativenumber

" Disable wrapping
set nowrap

" Keep cursor above/below N lines
set scrolloff=10

" Hide status bar
set laststatus=0

" Set default encoding
set encoding=utf8

" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" Automatically focus new splits
set splitbelow
set splitright

" Better command-line completion
set wildmenu
set wildmode=list:longest,full

" Disable error sounds
set noerrorbells
set novisualbell

" Turn off backups
set nobackup
set noswapfile
set nowb

" Allow mouse usage
set mouse=a

" Enable 24-bit colors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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
Plug 'sonph/onehalf', { 'rtp': 'vim' }
call plug#end()

" Sneak plugin settings
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" Set colorscheme
colorscheme onehalfdark
