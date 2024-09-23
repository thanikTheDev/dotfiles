local function telescope_selection(prompt_title, finder_options)
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    return coroutine.create(function(coro)
        local opts = {}
        pickers.new(opts, {
            prompt_title = prompt_title,
            finder = finders.new_oneshot_job(finder_options, {}),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function (buffer_number)
                actions.select_default:replace(function ()
                    actions.close(buffer_number)
                    coroutine.resume(coro, action_state.get_selected_entry()[1])
                end)
                return true
            end
        }):find()
    end)
end


local M = {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" },
            opts = {},
            main = "dapui",
        },
        "theHamsta/nvim-dap-virtual-text",
        "nvim-telescope/telescope.nvim",
    },
}

M.keys = {
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug Continue" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint Toggle" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint Condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>du", function() require("dap") require("dapui").toggle() end, desc = "Debug UI Toggle" },
    { "<leader>de", function() require("dap") require("dapui").eval() end, desc = "Debug Evaluation" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate Debug Session" },
}


function M.config()
    local dap = require "dap"
    local dapui = require "dapui"
    local dap_utils = require "dap.utils"

    local icons = {
        Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint          = " ",
        BreakpointCondition = " ",
        BreakpointRejected  = { " ", "DiagnosticError" },
        LogPoint            = ".>",
    }

    for name, sign in pairs(icons) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
            "Dap" .. name,
            { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
    end

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    dap.adapters.coreclr = {
        type = "executable",
        command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"),
        args = {"--interpreter=vscode"}
    }

    dap.adapters.godotCLR = {
        type = "executable",
        command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"),
        args = { "--interpreter=vscode", "--", "godot-mono"}
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "DOTNET: Launch",
            request = "launch",
            program = telescope_selection("Select DLL", {"fd", "--no-ignore", "-e", "dll"}),
        },
        {
            type = "godotCLR",
            name = "Godot: Launch Scene",
            request = "launch",
            program = telescope_selection("Select Scene", {"fd", "--no-ignore", "-e", "tscn"}),
        },
        {
            type = "coreclr",
            name = "Dotnet/Godot: Attach",
            request = "attach",
            processId = dap_utils.pick_process,
        }
    }

    dap.adapters.debugpy = {
        type = "executable",
        command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter"),
    }

    dap.configurations.python = {
        {
            type = "debugpy",
            name = "Launch File",
            request = "launch",
            module = "pywal",
            args = function()
                local args_string = vim.fn.input('Arguments: ')
                return vim.split(args_string, " +")
            end
        }
    }
end

return M
