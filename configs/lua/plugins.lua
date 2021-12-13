-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require("packer").startup(function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use "mhartington/formatter.nvim"
    use "neovim/nvim-lspconfig"

    use {
        "mfussenegger/nvim-lint",
        tag = "nvim-05",
    }
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
end)
