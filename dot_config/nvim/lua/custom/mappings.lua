---@type MappingsTable
local M = {}

M.general = {
    n = {
        ["<C-d>"] = {"<C-d>zz", "Jump Down"},
        ["<C-u>"] = {"<C-u>zz", "Jump Up"},
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
            "Continue"
        },
        ["<leader>db"] = {
            function()
                require("dap").toggle_breakpoint()
            end,
            "Toggle Breakpoint"
        },
        ["<leader>dB"] = {
            function()
                require("dap").set_breakpoint(vim.fn.input('Breakpoint Condition: '))
            end,
            "Breakpoint Condition"
        },
        ["<leader>do"] = {
            function()
                require("dap").step_over()
            end,
            "Step Over"
        },
        ["<leader>dO"] = {
            function()
                require("dap").step_out()
            end,
            "Step Out"
        },
        ["<leader>di"] = {
            function()
                require("dap").step_into()
            end,
            "Step Into"
        },
        ["<leader>du"] = {
            function()
                require("dap")
                require("dapui").toggle()
            end,
            "Toggle UI"
        },
        ["<leader>de"] = {
            function()
                require("dap")
                require("dapui").eval()
            end,
            "Evaluate"
        },
        ["<leader>dt"] = {
            function()
                require("dap").terminate()
            end,
            "Terminate"
        }
    }
}

-- more keybinds!

return M
