-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

function null_ls_setup()
    local null_ls = require "null-ls"
    local builtins = null_ls.builtins
    local on_attach = require("lsp_setup").on_attach

    null_ls.setup {
        sources = {
            builtins.diagnostics.teal,
        },
        on_attach = on_attach,
    }
end

return require("packer").startup(function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use "mhartington/formatter.nvim"
    use "neovim/nvim-lspconfig"
    use "teal-language/vim-teal"

    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = null_ls_setup,
    }

    use "mfussenegger/nvim-lint"

    use { "echasnovski/mini.nvim", branch = "stable" }

    use {
        "earthly/earthly.vim",
        branch = "main",
    }

    use {
        "ibhagwan/fzf-lua",
        requires = {
            "vijaymarupudi/nvim-fzf",
            "kyazdani42/nvim-web-devicons",
        },
    }

    use "mattn/emmet-vim"
    use "ziglang/zig.vim"
    use "alaviss/nim.nvim"
end)
