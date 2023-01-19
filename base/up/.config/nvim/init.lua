-- Plugins
require('packer').startup(function (use)
use 'wbthomason/packer.nvim'
use 'FelikZ/ctrlp-py-matcher'
use 'gpanders/nvim-parinfer'
use 'kien/ctrlp.vim'
use 'lifepillar/vim-solarized8'
use 'navarasu/onedark.nvim'
use 'neovim/nvim-lspconfig'
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'ray-x/lsp_signature.nvim'
end)

-- Options
vim.opt.autoindent               = true
vim.opt.backspace                = { 'indent', 'eol', 'start' }
vim.opt.belloff                  = 'all'
vim.opt.cc                       = '+1'
vim.opt.cino                     = { '(0', 't0', 'l1', 'g0' }
vim.opt.complete                 = { '.', 'w', 'b', 'u' }
vim.opt.completeopt              = { 'menu' }
vim.opt.diffopt:append('iwhite')
vim.opt.directory                = vim.fn.expand('~/.swp//')
vim.opt.encoding                 = 'utf-8'
vim.opt.expandtab                = true
vim.opt.fileformats              = { 'unix', 'dos' }
vim.opt.foldlevelstart           = 99
vim.opt.foldmethod               = 'indent'
vim.opt.hidden                   = true
vim.opt.hlsearch                 = true
vim.opt.incsearch                = true
vim.opt.laststatus               = 2
vim.opt.list                     = true
vim.opt.listchars                = { tab = ':>-', trail = '·' }
vim.opt.matchpairs:append('<:>')
vim.opt.mouse                    = 'a'
vim.opt.number                   = true
vim.opt.ruler                    = true
vim.opt.scrolloff                = 5
vim.opt.shiftwidth               = 4
vim.opt.showmode                 = true
vim.opt.signcolumn               = 'yes:1'
vim.opt.smartindent              = true
vim.opt.smarttab                 = true
vim.opt.softtabstop              = 8
vim.opt.tabpagemax               = 64
vim.opt.tabstop                  = 8
vim.opt.termguicolors            = true
vim.opt.textwidth                = 79
vim.opt.wildignore               = { 'a.out', '*.o', '*.a' }
vim.opt.wildmenu                 = true
vim.opt.wildmode                 = { 'longest:full', 'full' }
vim.opt.wrap                     = false

-- CtrlP Options
vim.g.ctrlp_cmd                 = 'CtrlP ~'
vim.g.ctrlp_user_command        = 'scan %s'
vim.g.ctrlp_max_files           = 0
vim.g.ctrlp_clear_cache_on_exit = 0
vim.g.ctrlp_match_func          = { match = 'pymatcher#PyMatch' }

-- Keymaps
vim.keymap.set('n', '<leader>r', '100A <Esc>d70|a// RETURN<Esc>')

-- Telescope Keymaps
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files)
vim.keymap.set('n', '<leader>fg', telescope.live_grep)
vim.keymap.set('n', '<leader>fb', telescope.buffers)
vim.keymap.set('n', '<leader>fh', telescope.help_tags)

-- Auto Commands
vim.api.nvim_create_autocmd({'FileType'}, {
    pattern = { '*.c', '*.cc', '*.cpp', '*.h' },
    callback = function (ev)
        vim.opt_local.cindent = true
    end
})

-- LSP configuration
local on_attach = function (client, bufnr)
    local function buf_set_keymap(lhs, rhs)
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true })
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
        vim.api.nvim_buf_set_keymap(
            bufnr,
            'n',
            '<C-s>',
            '<cmd>ClangdSwitchSourceHeader<CR>',
            { noremap = true, silent = true }
        )
    end,
    default_config = {
        filetypes = {'c', 'cc', 'cpp', 'h'},
    }
})

lsp.pyright.setup({ on_attach = on_attach })
lsp.tsserver.setup({ on_attach = on_attach })
lsp.rust_analyzer.setup({ on_attach = on_attach })

-- TreeSitter configuration
require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    incremental_selection = { enable = true },
})

-- OneDark colorscheme
require('onedark').setup({
    style = 'cool',
    ending_tildes = true,
    code_style = {
        comments = 'italic',
    },
})
require('onedark').load()

