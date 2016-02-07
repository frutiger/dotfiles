set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()
Plugin 'gmarik/vundle'

Plugin 'altercation/vim-colors-solarized'

syntax on
filetype plugin indent on

set hidden
set tabstop=8 softtabstop=8
set shiftwidth=4 expandtab smarttab
set backspace=indent,eol,start
set autoindent smartindent cindent cino+=(0,t0,l1,g0
set fileformats=unix,dos encoding=utf-8

set foldmethod=indent foldlevelstart=99
set incsearch hlsearch
set list listchars=tab:>-,trail:·
set nowrap
set textwidth=79
set matchpairs+=<:>
set diffopt+=iwhite completeopt-=preview

set number ruler showmode laststatus=2
set wildmenu wildmode=longest:full,full wildignore=a.out,*.o,*.a
set complete=.,w,b,u
set scrolloff=5
set mouse=a
set tabpagemax=64
set visualbell t_vb=
if &term=='xterm'
    set t_Co=256
endif

set directory=~/.swp//
let g:solarized_termtrans=1
set background=dark
colorscheme solarized

noremap <leader>i <Esc>yyPwdwiifndef INCLUDED<Esc>lr_vw~wDjo#endif<Esc>o<Esc>
noremap <leader>r 100A <Esc>d70\|a// RETURN<Esc>

if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  au BufEnter *.h,*.cpp,*.js,*.py highlight col_gt_80 ctermbg=red guibg=red
  au BufEnter *.h,*.cpp,*.js,*.py match col_gt_80 /\%>80c/
endif

Plugin 'kien/ctrlp.vim'
let g:ctrlp_cmd = 'CtrlP ~'
let g:ctrlp_user_command = 'scan %s'
let g:ctrlp_max_files = 0
let g:ctrlp_clear_cache_on_exit = 0

