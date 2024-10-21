" Display line numbers
set number

" Indentation settings
set tabstop=4
set shiftwidth=0  " follow tabstop
set softtabstop=-1  " follow shiftwidth
set autoindent
set list

" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" Disable wrapping
set nowrap

" Keep cursor above/below N lines
set scrolloff=12

" Allow mouse usage
set mouse=a

" Disable error sounds
set noerrorbells
set novisualbell

" Turn off backups
set nobackup
set noswapfile
set nowb

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
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
call plug#end()

" Set colorscheme
colorscheme onehalfdark
