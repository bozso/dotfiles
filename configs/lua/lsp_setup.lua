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
    "serve_d",
}

local function buf_set_keymap(bufnr, ...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

local function buf_set_option(bufnr, ...)
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
    gd = fmt(buf, "definition"),
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

local function on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = true

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    for key, val in pairs(keymaps) do
        buf_set_keymap(bufnr, "n", key, val, opts)
    end

    if client.name == "null-ls" then
        client.resolved_capabilities.completion = false
    end
end

for _, lsp in pairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
    }
end

local fmt = require "fmter_config"

lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    filetypes = { "go", "gomod", "gotmpl" },
    root_dir = function(fname)
        return util.root_pattern "go.work"(fname)
            or util.root_pattern("go.mod", ".git")(fname)
    end,
    single_file_support = true,
    default_config = {
        root_dir = [[root_pattern("go.mod", ".git")]],
    },
    settings = {
        gopls = {
            analyses = {
                nilness = true,
                shadow = true,
            },
        },
    },
    init_options = {
        analyses = {
            nilness = true,
            shadow = true,
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

function null_ls_setup()
    local null_ls = require "null-ls"
    local builtins = null_ls.builtins
    local fmt = builtins.formatting
    local diag = builtins.diagnostics
    local mydiag = require "diagnostics"
    local fmter = require "fmter_config"
    local lint = require "lint_config"

    srcs = {
        diag.teal,
        -- lint.cargo_check,
        diag.misspell,
        fmter.dprint,
        fmt.nimpretty,
        mydiag.dub,
        fmt.stylua.with {
            condition = function(utils)
                return utils.root_has_file {
                    "stylua.toml",
                    ".stylua.toml",
                }
            end,
        },
        -- diag.selene,
        -- sh, bash
        diag.shellcheck,
        fmt.shellharden,
        fmt.shfmt,
        -- golang
        diag.golangci_lint,
        fmt.goimports,
    }

    -- local cfg = require "null-ls.config"

    null_ls.setup {
        debug = true,
        sources = srcs,
        on_attach = on_attach,
    }
end

null_ls_setup()

return M
