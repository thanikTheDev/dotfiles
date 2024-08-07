local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

autocmd("VimEnter", {
    pattern = "*",
    command = "lua require('base46').load_all_highlights()",
})

local opt = vim.opt

opt.relativenumber = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
