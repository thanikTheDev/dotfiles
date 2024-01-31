local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

    -- Override plugin definition options

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- format & linting
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require "custom.configs.null-ls"
                end,
            },
        },
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end, -- Override to setup mason-lspconfig
    },

    {
        "folke/which-key.nvim",
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "whichkey")
            require("which-key").setup(opts)
            local present, wk = pcall(require, "which-key")
            if not present then
                return
            end
            wk.register({
                ["<leader>"] = {
                    d = { name = "Debug" }
                }
            })
        end,
        setup = function()
            require("core.utils").load_mappings("whichkey")
        end,
    },

    -- override plugin configs
    {
        "williamboman/mason.nvim",
        opts = overrides.mason
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
    },

    -- Install a plugin
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },

    {
        "lervag/vimtex",
        config = function()
            vim.g.vimtex_view_method = "zathura"
        end,
        ft = { "tex" }
    },

    {
        "duggiefresh/vim-easydir",
        lazy = false,
    },

    {
        "lambdalisue/suda.vim",
        lazy = false,
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    require("dapui").setup()
                end,
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                config = function()
                    require("nvim-dap-virtual-text").setup()
                end,
            },
        },
        init = function()
            require("core.utils").load_mappings "dap"
        end,
        config = function()
            require "custom.configs.nvim-dap"
        end,
    },

    -- To make a plugin not be loaded
    -- {
    --   "NvChad/nvim-colorizer.lua",
    --   enabled = false
    -- },

}

return plugins
