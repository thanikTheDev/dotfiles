local M = {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
}

M.keys = {
    -- find
    { "<leader>ff", "<cmd> Telescope find_files <CR>", desc = "Find files" },
    { "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find all" },
    { "<leader>fw", "<cmd> Telescope live_grep <CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd> Telescope buffers <CR>", desc = "Find buffers" },
    { "<leader>fh", "<cmd> Telescope help_tags <CR>", desc = "Help page" },
    { "<leader>fo", "<cmd> Telescope oldfiles <CR>", desc = "Find oldfiles" },
    { "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", desc = "Find in current buffer" },

    -- git
    { "<leader>gm", "<cmd> Telescope git_commits <CR>", desc = "Git commits" },
    { "<leader>gt", "<cmd> Telescope git_status <CR>", desc = "Git status" },
}

M.opts = {
    defaults = {
        file_ignore_patterns = {
            ".git/",
            ".vs/",
            ".min.js",
        },
        prompt_prefix = "  ",
        selection_caret = " ",
        path_display = { "smart" },
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        color_devicons = true,
    },
    pickers = {
        buffers = {
            theme = "dropdown",
            previewer = false,
        },
        live_grep = {
            theme = "ivy",
            glob_pattern = {
                "!.git/"
            },
            additional_args = function()
                return { "--hidden", "-L" }
            end
        }
    }
}

return M
