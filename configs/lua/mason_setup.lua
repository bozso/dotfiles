local M = {}

local tools = {
    -- rust
    { "rust-analyzer", version = "2022-08-08" },
    -- golang
    { "gopls", version = "v0.9.1" },
    { "golangci-lint", version = "v1.49.0" },
    { "gofumpt", version = "v0.3.1" },
    { "goimports", version = "v0.1.12" },
    -- TODO: integration with nvim
    { "gomodifytags", version = "v1.16.0" },
    -- TODO: integration with nvim
    { "impl", version = "latest" },
    -- protobuf
    { "buf", version = "v1.7.0" },
    -- C/C++
    "clangd",
    -- LaTeX, HTML, Markdown
    { "texlab", version = "v4.3.0" },
    { "tectonic", version = "tectonic@0.12.0" },
    { "marksman", version = "2022-08-07" },
    { "misspell", version = "v0.3.4" },
    -- lua
    { "selene", version = "0.20.0" },
    { "stylua", version = "v0.14.2" },
    { "lua-language-server", version = "v3.5.2" },
    -- zig
    { "zls", version = "0.9.0" },
}

function M.setup()
    require "import"

    import("mason", function(m)
        m.setup()
    end)

    import("mason-lspconfig", function(m)
        m.setup()
    end)

    import("mason-tool-installer", function(m)
        m.setup {
            ensure_installed = tools,

            -- if set to true this will check each tool for updates. If updates
            -- are available the tool will be updated. This setting does not
            -- affect :MasonToolsUpdate or :MasonToolsInstall.
            -- Default: false
            auto_update = false,

            -- automatically install / update on startup. If set to false nothing
            -- will happen on startup. You can use :MasonToolsInstall or
            -- :MasonToolsUpdate to install tools and check for updates.
            -- Default: true
            run_on_start = false,

            -- set a delay (in ms) before the installation starts. This is only
            -- effective if run_on_start is set to true.
            -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
            -- Default: 0
            start_delay = 3000, -- 3 second delay
        }
    end)
end

return M
