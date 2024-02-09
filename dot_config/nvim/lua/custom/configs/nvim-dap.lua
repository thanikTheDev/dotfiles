local dap = require "dap"
local dapui = require "dapui"

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
    -- command = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"),
    command = "/usr/local/netcoredbg",
    args = {"--interpreter=vscode"}
}

dap.adapters.godot = {
    type = "executable",
    command = "mono",
    args = { "/home/insidious_flames/godot-csharp-vscode/dist/GodotDebugSession/GodotDebugSession.exe" }
}

-- dap.adapters.unity = {
--     type = "executable",
--     command = "mono",
--     args = { "/home/insidious_flames/vscode-unity-debug/bin/UnityDebug.exe" }
-- }

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "DOTNET Core",
        request = "launch",
        program = function()
            return vim.fn.input("Path to dll:", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
    },
    {
        type = "coreclr",
        name = "Godot (Mono): Launch",
        request = "launch",
        program = "godot",
    }
}
