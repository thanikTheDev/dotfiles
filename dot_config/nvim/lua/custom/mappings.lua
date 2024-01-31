---@type MappingsTable
local M = {}

M.general = {
    n = {
        [";"] = { ":", "enter command mode", opts = { nowait = true } },
        ["<leader>ll"] = { "<cmd> VimtexCompile <CR>", "Vimtex Compile" },
    },
}

M.dap = {
    plugin = true,

    n = {
        ["<leader>dc"] = {
            function()
                require("dap").continue()
            end,
            "Debug Continue"
        },
        ["<leader>db"] = {
            function()
                require("dap").toggle_breakpoint()
            end,
            "Toggle Breakpoint"
        },
        ["<leader>do"] = {
            function()
                require("dap").step_over()
            end,
            "Step Over"
        },
        ["<leader>di"] = {
            function()
                require("dap").step_into()
            end,
            "Step Into"
        },
    }
}

-- more keybinds!

return M
