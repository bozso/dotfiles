-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require("packer").startup(function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use "nvim-treesitter/nvim-treesitter"

    use "neovim/nvim-lspconfig"

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    use "folke/lua-dev.nvim"

    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    }

    use {
        "L3MON4D3/LuaSnip",
    }

    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    }

    use { "echasnovski/mini.nvim", branch = "stable" }

    use {
        "ibhagwan/fzf-lua",
        requires = {
            "vijaymarupudi/nvim-fzf",
            "kyazdani42/nvim-web-devicons",
        },
    }

    use "mattn/emmet-vim"

    use {
        "earthly/earthly.vim",
        branch = "main",
    }

    use "nathom/filetype.nvim"

    -- extra language packages
    -- commented out for now, using treesitter for syntax highlight
    -- use "teal-language/vim-teal"
    -- use "ziglang/zig.vim"
    -- use "alaviss/nim.nvim"
end)
