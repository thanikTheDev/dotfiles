local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
}

M.opts = {
    ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "css",
        "html",
        "javascript",
        "lua",
        "markdown",
        "markdown_inline",
        "typescript",
        "vim",
        "vimdoc",
    },

    auto_install = true,

    highlight = { enable = true },

    indent = { enable = true },
}

return M
