local lspconfig = require("lspconfig")
local servers = { "pyright", "gopls", "clangd", "nimls"}

local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
end

local keymaps = {
    gD = "<cmd>lua vim.lsp.buf.declaration()<CR>",
    gd = "<cmd>lua vim.lsp.buf.defintion()<CR>",
    Gd = "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    ["<leader>h"] = "<cmd>lua vim.lsp.buf.hover()<CR>",
    ["<leader>d"] = "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
    ["<leader>H"] = "<cmd>lua vim.lsp.buf.signature_help()<CR>",
}

local opts = { noremap=true, silent=true }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    for key, val in pairs(keymaps) do
        buf_set_keymap("n", key, val,  opts)
    end
end

for _, lsp in pairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
    }
end

go = {
    {
        lintCommand = "golangci-lint run",
        lintFormats = {
            "%f:%l:%c: %rror: %m",
            "%f:%l:%c: %arning: %m",
        },
        lintStdin = true
    }
}

rust = {
    {
        -- src/service/string.rs:52:35: error[E0277]: `?` couldn't convert the error to `service::error::Error<database::Error<u64>>`
        lineCommand = "cargo check --message-format=short",
        lintFormats = {
            "%f:%l:%c: %error%m",
            "%f:%l:%c: %arning%m",
        },
        lintStdin = false,
    }
}

lspconfig.efm.setup {
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {formatCommand = "lua-format -i", formatStdin = true}
            },
            go = go,
            rust = rust,
        }
    }
}
