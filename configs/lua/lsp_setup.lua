local lspconfig = require("lspconfig")
local servers = { "pyright", "gopls", "clangd", }

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
