-- require "import"
local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local util = require "lspconfig.util"
local M = {}

local fmt = string.format

local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
    -- "pyre",
    "rust_analyzer",
    "rls",
    "pylsp",
    "clangd",
    "nimls",
    "zls",
    "julials",
    "rust_analyzer",
    "marksman",
}

local function buf_set_keymap(bufnr, ...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

local function buf_set_option(bufnr, ...)
    vim.api.nvim_buf_set_option(bufnr, ...)
end

local buf = "<cmd>lua vim.lsp.buf.%s()<CR>"
local diag = "<cmd>lua vim.diagnostic.%s()<CR>"

M.lua = "<cmd>lua %s<cr>"
M.fmt = "<cmd>lua require('utilities').format()<cr>"
M.fzf = "<cmd>lua require('fzf-lua').%s()<cr>"
M.fzf_w = fmt("%s<cmd>w<cr><cmd>lua require('fzf-lua').%%s()<cr>", M.fmt)

local keymaps = {
    gD = fmt(buf, "declaration"),
    gd = fmt(buf, "definition"),
    Gd = fmt(buf, "type_definition"),

    ["<leader>s"] = fmt(M.fzf_w, "lsp_workspace_symbols"),
    ["<leader>ds"] = fmt(M.fzf, "lsp_document_symbols"),
    ["<leader>wd"] = fmt(M.fzf, "lsp_workspace_diagnostics"),
    ["<leader>a"] = fmt(M.lua, "vim.lsp.buf.code_action()"),

    ["<leader>r"] = fmt(buf, "references"),
    ["<leader>rn"] = fmt(buf, "rename"),
    ["<leader>h"] = fmt(buf, "hover"),
    ["<leader>D"] = ":vsplit | lua vim.lsp.buf.definition()<CR>",

    ["<leader>d"] = fmt(diag, "open_float"),

    ["<C-k>"] = fmt(diag, "goto_prev"),
    ["<C-j>"] = fmt(diag, "goto_next"),
}

local opts = { noremap = true, silent = true }

function M.on_attach(_, bufnr)
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

    if not configs.golangcilsp then
        configs.golangcilsp = {
            default_config = {
                cmd = { "golangci-lint-langserver" },
                root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
                init_options = {
                    command = {
                        "golangci-lint",
                        "run",
                        "--enable-all",
                        "--disable",
                        "lll",
                        "--out-format",
                        "json",
                    },
                },
            },
        }
    end

    -- lspconfig.golangci_lint_ls.setup {
    --     filetypes = { "go", "gomod" },
    -- }

    lspconfig.texlab.setup {
        filetypes = { "tex", "bib", "plaintex" },
        single_file_support = true,
        settings = {
            texlab = {
                build = {
                    executable = "tectonic",
                    args = {
                        "-X",
                        "compile",
                        "%f",
                        "--synctex",
                        "--keep-logs",
                        "--keep-intermediates",
                    },
                },
                -- not implemented yet
                -- latexFormatter = "texlab",
            },
        },
    }

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
                formatting = {
                    gofumpt = true,
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

    -- local luadev = require("lua-dev").setup {
    --     library = {
    --         vimruntime = true, -- runtime path
    --         -- TODO: customize
    --         -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    --         types = true,
    --         -- installed opt or start plugins in packpath
    --         plugins = true,
    --         -- you can also specify the list of plugins to make available as a workspace library
    --         -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    --     },
    --     -- enable this to get completion in require strings. Slow!
    --     runtime_path = false,
    --     -- pass any additional options that will be merged in the final lsp config
    --     lspconfig = {
    --         -- cmd = {"lua-language-server"},
    --         -- on_attach = ...
    --     },
    -- }
    --
    -- lspconfig.sumneko_lua.setup(luadev)

    local efm = require "efm"

    lspconfig.efm.setup {
        cmd = {
            "efm-langserver",
            "-logfile",
            "/tmp/efm.log",
            "-loglevel",
            "1",
        },
        settings = {
            rootMarkers = { ".git/" },
            languages = efm,
        },
        filetypes = { "zig", "d" },
        single_file_support = false, -- This is the important line for supporting older version of EFM
    }
end

return M
