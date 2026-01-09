-- Plugins
require('packer').startup(function (use)
use 'wbthomason/packer.nvim'
use 'f-person/auto-dark-mode.nvim'
use 'gpanders/nvim-parinfer'
use 'lark-parser/vim-lark-syntax'
use 'navarasu/onedark.nvim'
use 'neovim/nvim-lspconfig'
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'ray-x/lsp_signature.nvim'
use 'sindrets/diffview.nvim'
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

-- Keymaps
vim.keymap.set('n', '<leader>r', '100A <Esc>d70|a// RETURN<Esc>')
vim.keymap.set('n', ' e', vim.diagnostic.open_float)

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

vim.api.nvim_create_autocmd({'LspAttach'}, {
    pattern = { '*' },
    callback = function (ev)
        require('lsp_signature').on_attach()
    end
})

vim.api.nvim_create_autocmd({'LspAttach'}, {
    pattern = { '*.c', '*.cc', '*.cpp', '*.h' },
    callback = function (ev)
        vim.keymap.set('n', '<C-s>', '<cmd>LspClangdSwitchSourceHeader<CR>')
    end
})

-- LSP enablements
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('ts_ls')

-- TreeSitter configuration
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'c',
        'cpp',
        'markdown',
        'markdown_inline',
        'python',
        'vim',
        'vimdoc',
    },
    highlight = { enable = true },
    incremental_selection = { enable = true },
})

-- OneDark colorscheme
require('onedark').setup({
    style = 'deep',
    ending_tildes = true,
    code_style = {
        comments = 'italic',
    },
})
require('onedark').load()

require('auto-dark-mode').setup({
    set_dark_mode = function()
        vim.opt.background = 'dark'
        require('onedark').set_options('style', 'deep')
        require('onedark').load()
    end,
    set_light_mode = function()
        vim.opt.background = 'light'
        require('onedark').set_options('style', 'light')
        require('onedark').load()
    end,
    update_interval = 1000,
    fallback = 'light'
})

