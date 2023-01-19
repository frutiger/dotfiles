-- iTerm2 Background
vim.api.nvim_create_autocmd({"VimEnter"}, {
    pattern = {"*"},
    callback = function (ev)
        normal_colors = vim.api.nvim_get_hl_by_name("Normal", 1)
        bg = normal_colors['background']
        fg = normal_colors['foreground']

        command = "silent !iterm2_set_bg_fg.py "
            .. "--bg " .. bg .. " "
            .. "--fg " .. fg .. " "
            .. "&"
        vim.api.nvim_command(command)
    end
})

vim.api.nvim_create_autocmd({"VimLeave"}, {
    pattern = {"*"},
    callback = function (ev)
        command = "silent !iterm2_set_bg_fg.py reset &"
        vim.api.nvim_command(command)
    end
})

