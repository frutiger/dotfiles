call plug#end()

set directory=~/.swp//

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
set textwidth=79 cc=+1
set matchpairs+=<:>
set diffopt+=iwhite completeopt-=preview

set number ruler showmode laststatus=2
set wildmenu wildmode=longest:full,full wildignore=a.out,*.o,*.a
set complete=.,w,b,u
set scrolloff=5
set mouse=a
set tabpagemax=64
set belloff=all

colorscheme solarized8

noremap <leader>i <Esc>yyPwdwiifndef INCLUDED<Esc>lr_vw~wDjo#endif<Esc>o<Esc>
noremap <leader>r 100A <Esc>d70\|a// RETURN<Esc>

let g:ctrlp_cmd = 'CtrlP ~'
let g:ctrlp_user_command = 'scan %s'
let g:ctrlp_max_files = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

