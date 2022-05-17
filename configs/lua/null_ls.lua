local lsp = require "lsp_setup"

function setup()
    local null_ls = require "null-ls"
    local builtins = null_ls.builtins
    local fmt = builtins.formatting
    local diag = builtins.diagnostics
    local fmter = require "fmter_config"
    local lint = require "lint_config"
    print(fmter.black)

    srcs = {
        -- python
        fmt.black,
        fmt.isort,
        diag.teal,
        -- html,css
        diag.tidy,
        diag.djlint,
        fmt.djlint,
        -- lint.cargo_check,
        diag.misspell,
        fmter.dprint,
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
