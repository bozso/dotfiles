local M = {}

function M.setup()
    require("mason").setup()
    require("mason-lspconfig").setup {
        ensure_installed = {
            "rust_analyzer@2022-08-08",
            -- golang
            "gopls@v0.9.1",
            "golangci-lint-langserver@v0.0.6",
            "goimports@v0.1.12",
            -- TODO: integration with nvim
            "gomodifytags@v1.16.0",
            -- TODO: integration with nvim
            "impl@latest",
            "buf@v1.7.0",
            "gofumpt@v1.3.1",
            -- C/C++
            "clangd",
            -- LaTeX, HTML, Markdown
            "ltex-ls@15.2.0",
            "marksman@2022-08-07",
            "misspell@v0.3.4",
            -- lua
            "selene@0.5.0",
            "stylua@v0.14.2",
            "sumneko_lua@v3.5.2",
            -- zig
            "zls@zls 0.9.0",
        },
    }
end

return M
