local dap = require "dap"
local dapui = require "dapui"
local dap_utils = require "dap.utils"

-- Telescope Dependencies
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

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

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

dap.adapters.coreclr = {
    type = "executable",
    command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"),
    args = {"--interpreter=vscode"}
}

dap.adapters.godotCLR = {
    type = "executable",
    command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"),
    args = { "--interpreter=vscode", "--", "godot"}
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "DOTNET: Launch",
        request = "launch",
        program = function()
            return coroutine.create(function (coro)
                local opts = {}
                pickers.new(opts, {
                    prompt_title = "Select DLL",
                    finder = finders.new_oneshot_job({"fd", "--no-ignore", "-e", "dll"}, {}),
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
        end,
    },
    {
        type = "godotCLR",
        name = "Godot: Launch Scene",
        request = "launch",
        program = function ()
            return coroutine.create(function (coro)
                local opts = {}
                pickers.new(opts, {
                    prompt_title = "Select Scene",
                    finder = finders.new_oneshot_job({"fd", "--no-ignore", "-e", "tscn"}, {}),
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
        end,
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
