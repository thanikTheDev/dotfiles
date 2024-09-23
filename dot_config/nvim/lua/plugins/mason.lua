-- Based on https://github.com/WilliamHsieh/dotfiles/blob/master/config/nvim/lua/plugins/lsp/mason.lua
local M = {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
}

---@type MasonSettings | { ensure_installed }
M.opts = {
    ui = {
        icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = "󰚌 ",
        },

        keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
            cancel_installation = "<C-c>",
        },
    },
    max_concurrent_installers = 10,
    ensure_installed = {
        -- lua
        "lua-language-server",
        "stylua",

        -- web
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "prettier",
        "astro-language-server",

        -- c/cpp
        "clangd",
        "clang-format",

        -- c#
        "omnisharp",
        "netcoredbg",
    }
}

function M.config(_, opts)
    require("mason").setup(opts)

    local registry = require("mason-registry")

    registry.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
            local p = registry.get_package(tool)
            if not p:is_installed() then
                p:install()
            end
        end
    end)
end

return M
