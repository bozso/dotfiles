-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- file manager
    -- use "SidOfc/carbon.nvim"

    use "nvim-treesitter/nvim-treesitter"

    use "neovim/nvim-lspconfig"

    -- efm-langserver configs
    use "creativenull/efmls-configs-nvim"

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

    use {
        "earthly/earthly.vim",
        branch = "main",
    }

    use "nathom/filetype.nvim"

    -- extra language packages
    -- commented out for now, using treesitter for syntax highlight
    -- use "teal-language/vim-teal"
    -- use "alaviss/nim.nvim"
end)
