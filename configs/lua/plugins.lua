-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Only if your version of Neovim doesn't have
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

local ut = require("utils")
local fmt = string.format

local format_file_extensions = {
    "c", "cpp", "cc", "cxx", "d", "py", "go", "js", "ts"
}

local extensions = {}
ut.add_patterns(".%s", format_file_extensions, extensions)

vim.api.nvim_exec(fmt([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost %s FormatWrite
augroup END
]], table.concat(extensions, ",")), true)

require('formatter').setup {
    filetype = {
        rust = {
            -- Rustfmt
            function()
                return {
                    exe = "rustfmt",
                    args = {"--emit=stdout"},
                    stdin = true
                }
            end
        },
    }
}

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use "mfussenegger/nvim-lint"
    use "mhartington/formatter.nvim"
    use "dense-analysis/ale"

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use {
        "earthly/earthly.vim",
        branch="main"
    }

    use {
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

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
