-- Global
vim.g.mapleader = " "


-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Keymap
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open NetRW" })
vim.keymap.set("n", "<leader>sh", vim.cmd.split, { desc = "Split Horizontal" })
vim.keymap.set("n", "<leader>sv", vim.cmd.vsplit, { desc = "Split Vertical" })
-- Switch Between Windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
-- Jump Through Buffer
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump Up" })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })

vim.keymap.set("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true})
vim.keymap.set("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true})
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent line" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Indent line" })

require "config.lazy"
require "config.autocmds"

vim.cmd.colorscheme "pywal16"
