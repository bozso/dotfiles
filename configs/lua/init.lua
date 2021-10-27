local ut = require("utils")
require("plugins")
require("fmter_config")
require("lsp_setup")


require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = "gruvbox",
        component_separators = {"|", "|"},
        section_separators = {" ", " "},
        disabled_filetypes = {}
    },
}

require("fzf-lua").setup {
}

require('lint').linters_by_ft = {
    c = {"clangtidy",},
    cpp = {"clangtidy",},
    go = {"golangcilint",},
}


vim.wo.colorcolumn = "79"

-- TODO: figure out how to change colorscheme properly
vim.cmd[[colorscheme delek]]


-- Ignore certain files and folders when globbing
local wildignore = ut.ignored_patterns {
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
    options = {
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
        user_emmet_leader_key = ',',
        wildignore = wildignore,
    },

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

ut.update_table {
    to = vim.opt,
    options = {
        tabstop = 4,
        softtabstop = 4,
        shiftwidth = 4,
        expandtab = true,
        number = true,
    }
}

local key_fn = vim.api.nvim_set_keymap

local function apply_keys(mode, keybinds, extra_opts)
    for key, val in pairs(keybinds) do
	key_fn(mode, key, val, extra_opts)
    end
end

nnoremaps = {
    ["<leader>f"] = ":w<C-j><cmd>lua require('fzf-lua').files()<cr>",
    ["<leader>b"] = ":w<C-j><cmd>lua require('fzf-lua').buffers()<cr>",
    ["<leader>g"] = ":w<C-j><cmd>lua require('fzf-lua').live_grep()<cr>",
    ["<leader>s"] = ":w<C-j><cmd>lua require('fzf-lua').lsp_workspace_symbols()<cr>",
    ["<leader>c"] = ":w<C-j><cmd>lua require('fzf-lua').lsp_code_actions()<cr>",
    ["<leader>ds"] = ":w<C-j><cmd>lua require('fzf-lua').lsp_document_symbols()<cr>",
    ["<leader>w"] = ":w<C-j>",
    -- ["<leader>d"] = ":ALEDetail<C-j>",
    -- ["<leader>h"] = ":ALEHover<C-j>",
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

    au BufWritePost <buffer> lua require('lint').try_lint()
]]
