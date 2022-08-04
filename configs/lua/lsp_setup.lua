local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
local util = require "lspconfig.util"
local M = {}

local fmt = string.format

local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
    -- "pyre",
    "pylsp",
    "clangd",
    "nimls",
    "zls",
    "julials",
    "rust_analyzer",
}

local function buf_set_keymap(bufnr, ...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

local function buf_set_option(bufnr, ...)
    vim.api.nvim_buf_set_option(bufnr, ...)
end

local lsp = "<cmd>lua vim.lsp.%s()<CR>"
local buf = "<cmd>lua vim.lsp.buf.%s()<CR>"
local diag = "<cmd>lua vim.diagnostic.%s()<CR>"

M.fmt = "<cmd>lua require('utils').format()<cr>"
M.fzf = "<cmd>lua require('fzf-lua').%s()<cr>"
M.fzf_w = fmt("%s<cmd>w<cr><cmd>lua require('fzf-lua').%%s()<cr>", M.fmt)

local keymaps = {
    gD = fmt(buf, "declaration"),
    gd = fmt(buf, "definition"),
    Gd = fmt(buf, "type_definition"),

    ["<leader>s"] = fmt(M.fzf_w, "lsp_workspace_symbols"),
    ["<leader>ds"] = fmt(M.fzf, "lsp_document_symbols"),
    ["<leader>wd"] = fmt(M.fzf, "lsp_workspace_diagnostics"),
    ["<leader>a"] = fmt(M.fzf, "lsp_code_actions"),

    ["<leader>r"] = fmt(buf, "references"),
    ["<leader>rn"] = fmt(buf, "rename"),
    ["<leader>h"] = fmt(buf, "hover"),
    ["<leader>H"] = fmt(buf, "signature_help"),

    ["<leader>d"] = fmt(diag, "open_float"),

    ["<C-k>"] = fmt(diag, "goto_prev"),
    ["<C-j>"] = fmt(diag, "goto_next"),
}

local opts = { noremap = true, silent = true }

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

function M.on_attach(client, bufnr)
    -- client.resolved_capabilities.document_formatting = true

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    for key, val in pairs(keymaps) do
        buf_set_keymap(bufnr, "n", key, val, opts)
    end
end

function M.setup_servers()
    for _, lsp in pairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
        }
    end

    lspconfig.gopls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        filetypes = { "go", "gomod", "gotmpl", "template" },
        root_dir = function(fname)
            return util.root_pattern "go.work"(fname)
                or util.root_pattern("go.mod", ".git")(fname)
        end,
        single_file_support = true,
        -- default_config = {
        --     root_dir = [[root_pattern("go.mod", ".git")]],
        -- },
        settings = {
            gopls = {
                buildFlags = { "-tags=mage" },
                templateExtensions = { "tmpl" },
                analyses = {
                    nilness = true,
                    shadow = true,
                    unusedparams = true,
                    fieldalignment = true,
                    unusedwrite = true,
                    useany = true,
                },
                staticcheck = true,
            },
        },
    }

    lspconfig.denols.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        root_dir = lspconfig.util.root_pattern "deno.json",
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "yaml",
            "json",
            "markdown",
            "html",
            "css",
        },
        init_options = {
            enable = true,
            lint = true,
            unstable = true,
            -- importMap = "./import_map.json",
        },
    }
end

return M
