call plug#begin()
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'folke/lsp-colors.nvim'
Plug 'gpanders/nvim-parinfer'
Plug 'kien/ctrlp.vim'
Plug 'navarasu/onedark.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ray-x/lsp_signature.nvim'
call plug#end()

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

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

noremap <leader>i <Esc>yyPwdwiifndef INCLUDED<Esc>lr_vw~wDjo#endif<Esc>o<Esc>
noremap <leader>r 100A <Esc>d70\|a// RETURN<Esc>

let g:ctrlp_cmd = 'CtrlP ~'
let g:ctrlp_user_command = 'scan %s'
let g:ctrlp_max_files = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

lua << EOF
local on_attach = function (client, bufnr)
    local function buf_set_keymap(lhs, rhs)
        vim.keymap.set('n', lhs, rhs, { buffer=bufnr, silent=true })
    end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    buf_set_keymap('<C-k>', vim.lsp.buf.signature_help)
    buf_set_keymap(' ca', vim.lsp.buf.code_action)
    buf_set_keymap(' e', vim.diagnostic.open_float)
    buf_set_keymap(' f', vim.lsp.buf.formatting)
    buf_set_keymap(' q', vim.diagnostic.setloclist)
    buf_set_keymap(' rn', vim.lsp.buf.rename)
    buf_set_keymap(' wl', function ()
        vim.pretty_print(vim.lsp.buf.list_workspace_folders())
    end)
    buf_set_keymap('K', vim.lsp.buf.hover)
    buf_set_keymap('gD', vim.lsp.buf.declaration)
    buf_set_keymap('gd', vim.lsp.buf.definition)
    buf_set_keymap('gi', vim.lsp.buf.implementation)
    buf_set_keymap('gI', vim.lsp.buf.incoming_calls)
    buf_set_keymap('gr', vim.lsp.buf.references)

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

require('onedark').setup  {
    -- Main options --
    style = 'cool', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false,  -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = '<leader>ts', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
    code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },

    -- Lualine options --
    lualine = {
        transparent = false, -- lualine center bar transparency
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}
require('onedark').load()
EOF

