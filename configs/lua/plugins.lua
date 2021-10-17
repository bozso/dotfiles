-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use "mfussenegger/nvim-lint"
    use "dense-analysis/ale"

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use {
        "earthly/earthly.vim",
        branch="main"
    }

    -- fuzzy finder vim support
    use {
        "junegunn/fzf", run = function()
            vim.call("fzf#install")
        end
    }

    use "junegunn/fzf.vim"
    use "mattn/emmet-vim"
    use "zah/nim.vim"
    use "ziglang/zig.vim"
end)
