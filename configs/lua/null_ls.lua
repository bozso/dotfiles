local lsp = require "lsp_setup"

local function setup()
    local null_ls = require "null-ls"
    local builtins = null_ls.builtins
    local actions = builtins.code_actions
    local completion = builtins.completion
    local fmt = builtins.formatting
    local diag = builtins.diagnostics
    local fmter = require "fmter_config"
    local mydiag = require "diagnostics"
    local django_fts = { "django", "jinja.html", "htmldjango", "html" }
    local on_save = null_ls.methods.DIAGNOSTICS_ON_SAVE

    local srcs = {
        completion.luasnip,
        builtins.completion.spell,
        -- python
        fmt.black,
        fmt.isort,
        diag.teal,
        -- html,css
        -- diag.tidy,
        diag.djlint.with {
            filetypes = django_fts,
        },
        fmt.djlint.with {
            filetypes = django_fts,
        },
        diag.misspell,
        -- lua
        fmt.stylua.with {
            condition = function(utils)
                return utils.root_has_file {
                    "stylua.toml",
                    ".stylua.toml",
                }
            end,
        },
        diag.selene,
        -- sh, bash
        actions.shellcheck,
        diag.shellcheck,
        fmt.shellharden,
        fmt.shfmt,
        -- golang
        fmt.golines,
        fmt.goimports,
        fmt.gofumpt,
        diag.golangci_lint.with {
            args = {
                "run",
                "--fix=false",
                "--enable-all",
                "--out-format=json",
                "$DIRNAME",
                "--path-prefix",
                "$ROOT",
            },
        },
        -- protobuf
        fmt.buf,
        diag.buf,
        -- Rust
        fmt.rustfmt,
        mydiag.clippy.with {
            method = on_save,
        },
        -- web, miscellaneous
        fmter.dprint,
        fmt.jq,
    }

    for _, src in pairs(srcs) do
        assert(src ~= nil)
    end

    -- local cfg = require "null-ls.config"

    local on_attach_ = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                -- on 0.8, you should use vim.lsp.buf.format instead
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end
    end

    on_attach_ = lsp.on_attach

    null_ls.setup {
        debug = true,
        sources = srcs,
        on_attach = on_attach_,
    }
end

setup()
