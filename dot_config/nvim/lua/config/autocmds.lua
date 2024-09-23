local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lspcmd"),
    callback = function(ev)
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "LSP definition", buffer = ev.buf })
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "LSP declaration", buffer = ev.buf })
        vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, { desc = "LSP hover", buffer = ev.buf })
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, { desc = "LSP implementation", buffer = ev.buf })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "LSP Signature Help", buffer = ev.buf })
    end,
})

-- user event that loads after UIEnter + only if file buf is there (Thanks NVChad)
vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
    group = augroup("FilePost"),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_buf_get_option(args.buf, "buftype")

        if not vim.g.ui_entered and args.event == "UIEnter" then
            vim.g.ui_entered = true
        end

        if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
            vim.api.nvim_del_augroup_by_name "FilePost"

            vim.schedule(function()
                vim.api.nvim_exec_autocmds("FileType", {})
            end, 0)
        end
    end,
})

vim.api.nvim_create_autocmd("Signal", {
    pattern = "SIGUSR1",
    group = augroup("toggle_colorscheme_on_SIGUSR1"),
    callback = function()
        require("pywal16").setup({})
        vim.schedule(function()
                vim.api.nvim_exec_autocmds("ColorScheme", {})
        end, 0)

    end
})
