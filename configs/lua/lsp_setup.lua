local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
local M = {}

local fmt = string.format

local servers = {
    "pyright",
    "gopls",
    "clangd",
    "nimls",
    "zls",
}

local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
end

local lsp = "<cmd>lua vim.lsp.%s()<CR>"
local buf = "<cmd>lua vim.lsp.buf.%s()<CR>"
local diag = "<cmd>lua vim.lsp.diagnostic.%s()<CR>"

M.fmt = "<cmd>lua require('utils').format()<cr>"
M.fzf = "<cmd>lua require('fzf-lua').%s()<cr>"
M.fzf_w = fmt("%s<cmd>w<cr><cmd>lua require('fzf-lua').%%s()<cr>", M.fmt)

local keymaps = {
    gD = fmt(buf, "declaration"),
    gd = fmt(buf, "defintion"),
    Gd = fmt(buf, "type_definition"),

    ["<leader>s"] = fmt(M.fzf_w, "lsp_workspace_symbols"),
    ["<leader>ds"] = fmt(M.fzf, "lsp_document_symbols"),

    ["<leader>r"] = fmt(buf, "references"),
    ["<leader>rn"] = fmt(buf, "rename"),
    ["<leader>h"] = fmt(buf, "hover"),
    ["<leader>H"] = fmt(buf, "signature_help"),

    ["<leader>d"] = fmt(diag, "show_line_diagnostics"),

    ["<C-k>"] = fmt(diag, "goto_prev"),
    ["<C-j>"] = fmt(diag, "goto_next"),
}

local opts = { noremap = true, silent = true }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    for key, val in pairs(keymaps) do
        buf_set_keymap("n", key, val, opts)
    end
end

for _, lsp in pairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
    }
end

local fmt = require "fmter_config"

lspconfig.efm.setup {
    init_options = { documentFormatting = true },
    flags = { debounce_text_changes = 150 },
    filetypes = {
        "python",
        "lua",
        "yaml",
        "json",
        "markdown",
        "javascript",
        "typescript",
        "rust",
    },
    settings = {
        rootMarkers = { ".git/", "Cargo.toml" },
        languages = fmt.languages,
    },
}

lspconfig.haxe_language_server.setup {
    cmd = { "node", "/home/istvan/packages/bin/server.js" },
}

return M
