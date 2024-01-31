local dap = require "dap"
local dapui = require "dapui"

vim.api.nvim_set_hl(0, "red", { fg = "#FB4934" })

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'red', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'red', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

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
    command = "netcoredbg",
    args = {"--interpreter=vscode"}
}

-- dap.adapters.godot = {
--     type = "executable",
--     command = "mono",
--     args = { "/home/insidious_flames/godot-csharp-vscode/dist/GodotDebugSession/GodotDebugSession.exe" }
-- }

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
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
    },
    -- {
    --     type = "godot",
    --     name = "Godot",
    --     request = "launch",
    --     project = "${workspaceFolder}",
    --     launch_scene = true,
    -- }
}
