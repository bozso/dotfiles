-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()


return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use "mfussenegger/nvim-lint"
    use "mhartington/formatter.nvim"
    use "dense-analysis/ale"
    use "neovim/nvim-lspconfig"

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use {
        "earthly/earthly.vim",
        branch="main"
    }

    use {
        'ibhagwan/fzf-lua',
        requires = {
            'vijaymarupudi/nvim-fzf',
        }
    }

    -- use {
    --     "nvim-telescope/telescope.nvim",
    --     requires = { {"nvim-lua/plenary.nvim"} }
    -- }

    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    }

    use "mattn/emmet-vim"
    use "zah/nim.vim"
    use "ziglang/zig.vim"
end)
