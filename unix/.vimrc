call plug#begin()
Plug 'lifepillar/vim-solarized8'
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
if has('nvim')
    Plug 'neovim/nvim-lspconfig'
    Plug 'folke/lsp-colors.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

