return {
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                --{ "<leader><tab>", group = "tabs" },
                --{ "<leader>c", group = "code" },
                { "<leader>f", group = "file/find" },
                { "<leader>g", group = "git" },
                --{ "<leader>gh", group = "hunks" },
                --{ "<leader>q", group = "quit/session" },
                --{ "<leader>s", group = "search" },
                --{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                --{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                { "[", group = "prev" },
                { "]", group = "next" },
                { "g", group = "goto" },
                --{ "gs", group = "surround" },
                { "z", group = "fold" },
            },
        },
        event = "VeryLazy",
        keys = { "<leader>", "g" },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "pywal16-nvim",
                component_separators = { left = "\\", right = "/" },
                section_separators = { left = "", right = "" },
            },
        },
        event = "UIEnter",
    },
    {
        "lervag/vimtex",
        init = function() vim.g.vimtex_view_method = "zathura" end,
        ft = { "tex" },
        keys = {
            { "<leader>ll", "<cmd> VimtexCompile <CR>", desc = "Vimtex Compile" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function()
                vim.keymap.set("n", "<leader>gb", function() package.loaded.gitsigns.blame_line() end, { desc = "Blame line" })
            end
        },
        event = "User FilePost",
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function(_, opts)
            require("colorizer").setup(opts)

            vim.defer_fn(function ()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end,
        event = "User FilePost",
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {
            size = 12,
            open_mapping = [[<esc>]],
            direction = "horizontal"
        },
        keys = {
            { "<leader>t", function() require("toggleterm").toggle_command() end, desc = "Toggle Terminal" },
        },
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
        keys = {
            { "<leader>/", function() require("Comment.api").toggle.linewise.current() end, desc = "Toggle Comment" },
            { "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", mode = "v", desc = "Toggle Comment" },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {},
        main = "ibl",
        event = "User FilePost",
    },
    {
        "lambdalisue/suda.vim",
        event = "User FilePost",
    },
    {
        "uZer/pywal16.nvim",
        opts = {},
    },
    {
        "stevearc/dressing.nvim",
        opts = {
            input = {
                get_config = function(opts)
                    if opts.kind == "input_center" then
                        return {
                            title_pos = "center",
                            relative = "editor",
                        }
                    end
                end
            }
        },
        event = "UIEnter",
    }
}
