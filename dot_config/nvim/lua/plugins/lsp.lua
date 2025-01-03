local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "Hoffs/omnisharp-extended-lsp.nvim",
    },
    event = "User FilePost",
}

function M.config()
    local lspconfig = require "lspconfig"
    local omnisharp_extended = require "omnisharp_extended"

    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texth1 = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config {
        update_in_insert = true,
        underline = true,
        severity_sort = true,
    }

    -- if you just want default config for the servers then put them in a table
    local servers = { "clangd", "html", "cssls", "ts_ls", "astro", "rust_analyzer", "bashls", "pyright" }

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {}
    end

    lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    }

    lspconfig.omnisharp.setup {
        on_attach = function(client, _)
            client.server_capabilities.semanticTokensProvider.legend = {
                tokenModifiers = { "static" },
                tokenTypes = { "comment", "excluded", "identifier", "keyword", "keyword", "number", "operator", "operator",
                    "preprocessor", "string", "whitespace", "text", "static", "preprocessor", "punctuation", "string",
                    "string", "class", "delegate", "enum", "interface", "module", "struct", "typeParameter", "field",
                    "enumMember", "constant", "local", "parameter", "method", "method", "property", "event", "namespace",
                    "label", "xml", "regexp" }
            }
        end,
        capabilities = capabilities,
        handlers = {
            ['textDocument/definition'] = omnisharp_extended.handler,
            ['textDocument/typeDefinition'] = omnisharp_extended.handler,
            ['textDocument/references'] = omnisharp_extended.handler,
            ['textDocument/implementation'] = omnisharp_extended.handler,
        },
        settings = {
            OrganizeImports = true,
        },
        RosylnExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            EnableDecompilationSupport = true,
        },
        cmd = { "omnisharp" }
    }
end

return M
