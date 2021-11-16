local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

configs.please = {
    default_config = {
        cmd = { "build_langserver" },
        filetypes = { "BUILD", },
        root_dir = function(filename)
            return util.path.dirname(filename)
        end,
    },
}

local servers = {
    "pyright", "gopls", "clangd", "nimls", "rust_analyzer",
    "serve_d", "please",
}

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
        lineCommand = "cargo check --message-format=short",
        lintFormats = {
            "%f:%l:%c: %rror%m",
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
            go = go,
            rust = rust,
        }
    }
}
