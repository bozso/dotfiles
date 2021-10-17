local ut = require("utils")
require("plugins")


require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = "gruvbox",
        component_separators = {"|", "|"},
        section_separators = {"|", "|"},
        disabled_filetypes = {}
    },
}

local fmt = string.format

vim.wo.colorcolumn = "79"

-- TODO: figure out how to change colorscheme properly
vim.cmd("colorscheme delek")

local function apply_dict(dict, options)
    for key, opt in pairs(options) do
        dict[key] = opt
    end
end

local options = {
    wildignore = "*.o",
}

local o = vim.o

apply_dict(vim.o, options)

local ale_linters = {
   go = {'gofmt', 'golint', 'govet', 'gobuild', 'golangci-lint'},
   d = {'dls', 'dmd'},
   python = {'flake8', 'pylint', 'pyre', 'mypy', 'pyright'},
   typescript = {'deno'},
   nim = {'nimcheck', 'nimlsp'},
}


local ale_fixers = {
    ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
    rust = {'rustfmt'},
    go = {'gofmt'},
    c = {'clang-format', 'clangtidy'},
    cpp = {'clang-format', 'clangtidy'},
    python = {'black'},
    typescript = {'deno'},
}

local function add_patterns(tpl, iter, to)
    for _, ext in pairs(iter) do
        table.insert(to, fmt(tpl, ext))
    end
end

local function ignored_patterns(opts)
    local ignores = {}
    for tpl, iter in pairs(opts) do
        add_patterns(tpl, iter, ignores)
    end
    return ignores
end

-- Ignore certain files and folders when globbing
local wildignore = ignored_patterns {
    ["*.%s"] = {
        "o", "obj", "bin", "dll", "exe", "jpg", "png", "jpeg",
        "bmp", "gif", "tiff", "svg", "ico", "pyc", "DS_store",
        "aux", "bbl", "blg", "brf", "fls", "fdb_latexmk",
        "synctex.gz"
    },
    ["*/%s/"] = {".git", ".svn", "__pycache__"},
    ["*/%s/**"] = {"build",},
}

ut.update_table {
    to = vim.g,
    groups = {
        ale_ = {
            fix_on_save = 1,
            lint_on_text_changed = 0,
            lint_on_insert_leave = 0,
            completion_autoimport = 1,
            go_golangci_lint_executable = 'golangci-lint',
            fixers = {

                ['*'] = {
                    'remove_trailing_lines', 'trim_whitespace'
                },
                rust = {'rustfmt'},
                go = {'gofmt'},
                c = {'clang-format', 'clangtidy'},
                cpp = {'clang-format', 'clangtidy'},
                python = {'black'},
                typescript = {'deno'},
            },
            linters = {
                go = {
                    'gofmt', 'golint', 'govet', 'gobuild',
                    'golangci-lint'
                },
                d = {'dls', 'dmd'},
                python = {
                    'flake8', 'pylint', 'pyre', 'mypy',
                    'pyright'
                },
                typescript = {'deno'},
                nim = {'nimcheck', 'nimlsp'},
            }
        }
    }
}


local globals = {
    fileencodings = {
        "utf-8", "ucs-bom", "cp936", "gb18030", "big5",
        "euc-jp", "euc-kr", "latin1"
    },

    -- do not use visual and errorbells
    visualbell = "noerrorbells",
    -- the number of command and search history to keep
    history = 500,

    -- ignore file and dir name cases in cmd-completion
    wildignorecase = true,

    -- fileformats to use for new files
    fileformats = {"unix", "dos"},

    -- break line at predefined characters
    linebreak = true,
    noswapfile = true,
    colorscheme = "delek",
    mapleader = " ",
    ["airline#extensions#ale#enabled"] = 1,
    user_emmet_leader_key = ',',
    wildignore = wildignore
}

apply_dict(vim.g, globals)


local opts = {
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    number = true,
}

apply_dict(vim.opt, opts)

--[[
    Plugin management with plug.
    TODO: replace plugin management with paq or packer
--]]

--[[
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('earthly/earthly.vim', {branch="main"})
Plug('junegunn/fzf', {
    ['do'] = function()
        vim.call("fzf#install")
    end
})

-- Fuzzy finder vim support
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'dense-analysis/ale'
Plug 'flazz/vim-colorschemes'
Plug 'mattn/emmet-vim'
Plug 'zah/nim.vim'
Plug 'ziglang/zig.vim'

vim.call('plug#end')
--]]

local key_fn = vim.api.nvim_set_keymap

local function apply_keys(mode, keybinds, extra_opts)
    for key, val in pairs(keybinds) do
	key_fn(mode, key, val, extra_opts)
    end
end

nnoremaps = {
    ["<leader>f"] = ":w<C-j>:FZF<C-j>",
    ["<leader>w"] = ":w<C-j>",
    ["<leader>b"] = ":w<C-j>:buffer<space>",
    ["<leader>d"] = ":ALEDetail<C-j>",
    ["<leader>h"] = ":ALEHover<C-j>",
}

apply_keys("n", nnoremaps, {noremap = true})

nmaps = {
    ["<C-k>"] = "<Plug>(ale_previous_wrap)",
    ["<C-j>"] = "<Plug>(ale_next_wrap)",
}

apply_keys("n", nmaps, {silent = true})

--[[
TODO: figure out how to port this to lua
UI-related settings
General settings about colors
Enable true colors support. Do not set this option if your terminal does not
support true colors! For a comprehensive list of terminals supporting true
colors, see https://github.com/termstandard/colors and
https://gist.github.com/XVilka/8346728.
--]]

vim.cmd[[
    if match($TERM, '^xterm.*') != -1 || exists('g:started_by_firenvim')
      set termguicolors
    endif
]]
