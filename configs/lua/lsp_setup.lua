local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
local M = {}

local fmt = string.format

configs.please = {
    default_config = {
        cmd = { "build_langserver" },
        filetypes = { "BUILD" },
        root_dir = function(filename)
            return util.path.dirname(filename)
        end,
    },
}

local servers = {
    "pyright",
    "gopls",
    "clangd",
    "nimls",
    -- "rust_analyzer",
    "serve_d",
    "please",
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

M.fzf = "<cmd>lua require('fzf-lua').%s()<cr>"
-- M.fzf_w = "<cmd>Format<cr><cmd>w<cr><cmd>lua require('fzf-lua').%s()<cr>"
M.fzf_w =
    "<cmd>lua vim.lsp.buf.formatting_sync()<cr><cmd>w<cr><cmd>lua require('fzf-lua').%s()<cr>"

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

local lua = {
    {
        formatCommand = "stylua",
    },
}

lspconfig.efm.setup {
    init_options = { documentFormatting = false },
    settings = {
        rootMarkers = { ".git/", "Cargo.toml" },
        languages = {
            lua = lua,
        },
    },
}

return M
