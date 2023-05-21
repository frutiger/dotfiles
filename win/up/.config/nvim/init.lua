-- Windows Options
vim.opt.wildignore = { "*.exe", "*.dll", "*.obj", "*.lib" }
vim.opt.shell      = "C:\\\\Windows\\\\System32\\\\cmd.exe"

-- ignore ctrl+z since it suspends the process and Windows Terminal can't
-- resume it
vim.keymap.set({'n', 'v', 'o', 'i'}, '<C-z>', function () end)

