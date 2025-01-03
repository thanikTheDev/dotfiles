local function select_program(prompt_title, program_search_command)
    return function()
        return coroutine.create(function(coro)
            vim.ui.select(
                vim.split(vim.fn.system(program_search_command), "\n"),
                { prompt = prompt_title },
                function(selected) coroutine.resume(coro, selected) end
            )
        end)
    end
end

local function set_program_arguments()
    return function()
        return coroutine.create(function(coro)
            vim.ui.input({ prompt = "Program Arguments", kind = "input_center" }, function(params) coroutine.resume(coro, vim.split(params, " ")) end)
        end)
    end
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
        args = { "--interpreter=vscode" }
    }

    dap.adapters.godotCLR = {
        type = "executable",
        command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"),
        args = { "--interpreter=vscode", "--", "godot-mono" }
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "DOTNET: Launch",
            request = "launch",
            program = select_program("Select DLL", "fd -Ie dll"),
            args = set_program_arguments()
        },
        {
            type = "godotCLR",
            name = "Godot: Launch Scene",
            request = "launch",
            program = select_program("Select Scene", "fd -Ie tscn"),
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
            args = set_program_arguments()
        }
    }
end

return M
