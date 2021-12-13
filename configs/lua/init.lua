require "plugins"
require "statusline"
require "fmter_config"
require "lint_config"

local ut = require "utils"
local lsp = require "lsp_setup"

local fmt = string.format

local base16 = require "mini.base16"
local palette = base16.mini_palette("#e2e5ca", "#002a83", 75)
base16.setup { palette = palette, name = "minischeme", use_cterm = true }
vim.o.background = "light"

require("mini.comment").setup()
require("mini.completion").setup {
    lsp_completion = {
        source_func = "omnifunc",
        auto_setup = true,
    },
}

require("mini.misc").setup {
    --Array of fields to make global (to be used as independent variables)
    make_global = { "put", "put_text" },
}

require("mini.pairs").setup {
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = false, terminal = false },

    -- Global mappings. Each right hand side should be a pair information, a
    -- table with at least these fields (see more in `:h MiniPairs.map`):
    -- - `action` - one of 'open', 'close', 'closeopen'.
    -- - `pair` - two character string for pair to be used.
    -- By default pair is not inserted after `\`, quotes are not recognized by
    -- `<CR>`, `'` does not insert pair after a letter.
    -- Only parts of the tables can be tweaked (others will use these defaults).
    mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        ['"'] = {
            action = "closeopen",
            pair = '""',
            neigh_pattern = "[^\\].",
            register = { cr = false },
        },

        ["'"] = {
            action = "closeopen",
            pair = "''",
            neigh_pattern = "[^%a\\].",
            register = { cr = false },
        },

        ["`"] = {
            action = "closeopen",
            pair = "``",
            neigh_pattern = "[^\\].",
            register = { cr = false },
        },
    },
}

require("fzf-lua").setup {
    border = { "+", "─", "+", "│", "+", "─", "+", "│" },
}

-- TODO: figure out how to change colorscheme properly
local status, err = pcall(vim.cmd, "colorscheme minischeme")

if not status then
    -- vim.notify()
    vim.cmd [[colorscheme delek]]
end

vim.wo.colorcolumn = "79"

-- Ignore certain files and folders when globbing
-- stylua: ignore
local wildignore = ut.ignored_patterns {
    ["*.%s"] = {
        "o", "obj", "bin", "dll", "exe", "jpg", "png", "jpeg", "bmp", "gif",
        "tiff", "svg", "ico", "pyc", "DS_store", "aux", "bbl", "blg", "brf",
        "fls", "fdb_latexmk", "synctex.gz",
    },
    ["*/%s/"] = { ".git", ".svn", "__pycache__" },
    ["*/%s/**"] = { "build" },
}

-- stylua: ignore
ut.update_table {
    to = vim.g,
    options = {
        fileencodings = {
            "utf-8", "ucs-bom", "cp936", "gb18030", "big5", "euc-jp",
            "euc-kr", "latin1",
        },

        -- do not use visual and errorbells
        visualbell = "noerrorbells",
        -- the number of command and search history to keep
        history = 500,

        -- ignore file and dir name cases in cmd-completion
        wildignorecase = true,

        -- fileformats to use for new files
        fileformats = { "unix", "dos" },

        -- break line at predefined characters
        linebreak = true,
        noswapfile = true,
        colorscheme = "delek",
        mapleader = " ",
        user_emmet_leader_key = ",",
        wildignore = wildignore,
    },
}

ut.update_table {
    to = vim.opt,
    options = {
        tabstop = 4,
        softtabstop = 4,
        shiftwidth = 4,
        expandtab = true,
        number = true,
    },
}

local key_fn = vim.api.nvim_set_keymap

local function apply_keys(mode, keybinds, extra_opts)
    for key, val in pairs(keybinds) do
        key_fn(mode, key, val, extra_opts)
    end
end

local fzf_w = lsp.fzf_w

nnoremaps = {
    ["<leader>f"] = fmt(fzf_w, "files"),
    ["<leader>b"] = fmt(fzf_w, "buffers"),
    ["<leader>g"] = fmt(fzf_w, "live_grep"),

    ["<leader>c"] = "<cmd>close<cr>",

    ["<leader>w"] = fmt("%s<cmd>w<C-j>", lsp.fmt),
    ["<leader>sv"] = "<cmd>source $MYVIMRC<cr>",
}

apply_keys("n", nnoremaps, { noremap = true })

--[[
TODO: figure out how to port this to lua
UI-related settings
General settings about colors
Enable true colors support. Do not set this option if your terminal does not
support true colors! For a comprehensive list of terminals supporting true
colors, see https://github.com/termstandard/colors and
https://gist.github.com/XVilka/8346728.
--]]

vim.cmd [[
    if match($TERM, '^xterm.*') != -1 || exists('g:started_by_firenvim')
      set termguicolors
    endif

    au BufRead,BufNewFile *.build_defs if &ft == '' | setfiletype bzl | endif
    au BufWritePost <buffer> lua require('lint').try_lint()
]]
