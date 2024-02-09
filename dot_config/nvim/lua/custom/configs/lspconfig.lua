local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local utils = require "core.utils"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "astro", "rust_analyzer" }

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

--
-- lspconfig.pyright.setup { blabla}

lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--offset-encoding=utf-16"
    }
}

lspconfig.omnisharp.setup {
    on_attach = function(client, bufnr)
        utils.load_mappings("lspconfig", { buffer = bufnr })

        if client.server_capabilities.signatureHelpProvider then
            require("nvchad_ui.signature").setup(client)
        end

        client.server_capabilities.semanticTokensProvider.legend = {
            tokenModifiers = { "static" },
            tokenTypes = { "comment", "excluded", "identifier", "keyword", "keyword", "number", "operator", "operator",
                "preprocessor", "string", "whitespace", "text", "static", "preprocessor", "punctuation", "string",
                "string", "class", "delegate", "enum", "interface", "module", "struct", "typeParameter", "field",
                "enumMember", "constant", "local", "parameter", "method", "method", "property", "event", "namespace",
                "label", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml",
                "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "regexp", "regexp", "regexp", "regexp", "regexp",
                "regexp", "regexp", "regexp", "regexp" }
        }
    end,
    organize_imports_on_format = true,
    enable_import_completion = true,
    sdk_include_prereleases = true,
    capabilities = capabilities,
    cmd = { vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/bin/omnisharp") }
}
