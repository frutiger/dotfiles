call plug#begin()
Plug 'lifepillar/vim-solarized8'
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
if has('nvim')
    Plug 'neovim/nvim-lspconfig'
    Plug 'folke/lsp-colors.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'ray-x/lsp_signature.nvim'

    nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
    nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
    nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
    nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
endif
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
set signcolumn=yes:1 textwidth=79 cc=+1
set matchpairs+=<:>
set diffopt+=iwhite
set completeopt=menu,menuone,noselect

set number ruler showmode laststatus=2
set wildmenu wildmode=longest:full,full wildignore=a.out,*.o,*.a
set complete=.,w,b,u
set scrolloff=5
set mouse=a
set tabpagemax=64
set belloff=all

set termguicolors
colorscheme solarized8

noremap <leader>i <Esc>yyPwdwiifndef INCLUDED<Esc>lr_vw~wDjo#endif<Esc>o<Esc>
noremap <leader>r 100A <Esc>d70\|a// RETURN<Esc>

let g:ctrlp_cmd = 'CtrlP ~'
let g:ctrlp_user_command = 'scan %s'
let g:ctrlp_max_files = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

if has('nvim')
lua << EOF
    local on_attach = function (client, bufnr)
        local function buf_set_keymap(lhs, rhs)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap=true, silent=true })
        end

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        buf_set_keymap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        buf_set_keymap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        buf_set_keymap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        buf_set_keymap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        buf_set_keymap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        buf_set_keymap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        buf_set_keymap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        buf_set_keymap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        buf_set_keymap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        buf_set_keymap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
        buf_set_keymap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
        buf_set_keymap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
        buf_set_keymap('<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
        buf_set_keymap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

        require('lsp_signature').on_attach()
    end

    local lsp = require('lspconfig')

    lsp.clangd.setup({
        cmd = { 'clangd', '--background-index', '--completion-style=detailed' },
        on_attach = function (client, bufnr)
            on_attach(client, bufnr)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', '<cmd>ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })
        end,
        default_config = {
            filetypes = {'c', 'cc', 'cpp', 'h'},
        }
    })

    lsp.pyright.setup({ on_attach = on_attach })
    lsp.tsserver.setup({ on_attach = on_attach })
    lsp.rust_analyzer.setup({ on_attach = on_attach })

    require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        incremental_selection = { enable = true },
    })
EOF
endif

