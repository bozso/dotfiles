require "import"
import "plugins"
import "statusline"
import "fmter_config"
-- import "lint_config"

local format = string.format
local ut = require "utilities"
local lsp = require "lsp_setup"
local ts = require "tree_sitter"
local mason = require "mason_setup"
local lsp_diag = require "lsp_diag"
local pkgs = require "packages"

require("null_ls").setup()
import("leap", function(leap)
    leap.add_default_mappings()
end)

vim.diagnostic.config { virtual_text = false }

mason.setup()
lsp.setup_servers()
ts.setup()
lsp_diag.setup()

vim.api.nvim_create_user_command("Install", pkgs.install, {})

local fmt = string.format
vim.o.background = "light"

-- TODO: figure out how to change colorscheme properly
local colorscheme = "mycolors"
local colorscheme_cmd = format("colorscheme %s", colorscheme)
local status, _ = pcall(vim.cmd, colorscheme_cmd)

if not status then
    vim.cmd [[colorscheme delek]]
end

local notify = vim.notify
vim.notify = function(msg, ...)
    if msg:match "warning: multiple different client offset_encodings" then
        return
    end

    notify(msg, ...)
end

require("mini.comment").setup {}

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

require("mini.surround").setup {
    -- Number of lines within which surrounding is searched
    n_lines = 20,

    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
    highlight_duration = 500,

    -- Add custom surroundings to be used on top of builtin ones. For more
    -- information with examples, see `:h MiniSurround.config`.
    custom_surroundings = nil,

    -- How to search for surrounding (first inside current line, then inside
    -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
    -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
    search_method = "cover",

    -- Mappings. Use `''` (empty string) to disable one.
    mappings = {
        add = "sa", -- Add surrounding
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
    },
}

require("filetype").setup {
    overrides = {
        extensions = {
            tl = "teal",
            django = "htmldjango",
        },
    },
}
require("fzf-lua").setup {}

local nvim_share = "/home/istvan/.local/share/nvim/site/pack/packer/start"

vim.api.nvim_create_user_command("Plugins", fmt(":e %s", nvim_share), {})

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

local new_fo = table.insert(vim.opt.fo, "a")
ut.update_table {
    to = vim.opt,
    options = {
        fo = new_fo,
        splitright = true,
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

local set_key = vim.keymap.set
local function set_keys(mode, keybinds, extra_opts)
    for key, val in pairs(keybinds) do
        set_key(mode, key, val, extra_opts)
    end
end

local fzf_w = lsp.fzf_w

local nnoremaps = {
    ["<leader>p"] = "<cmd>FzfLua commands<cr>",
    ["<leader>j"] = "<cmd>FzfLua<cr>",
    ["<leader>f"] = fmt(fzf_w, "files"),
    ["<leader>b"] = fmt(fzf_w, "buffers"),
    ["<leader>g"] = fmt(fzf_w, "live_grep"),

    ["<leader>c"] = "<cmd>close<cr>",
    ["<leader>t"] = "<cmd>Trouble<cr>",

    ["<leader>w"] = fmt("%s<cmd>w<C-j>", lsp.fmt),
    ["<leader>sv"] = "<cmd>source $MYVIMRC<cr>",
    ["<leader>e"] = ":e %:h/",
}

-- TODO: refactor this into separate directory
local ls = require "luasnip"

-- file named _.snippets applies to all files
-- TODO: this does not work
ls.filetype_extend("all", { "_" })

require("luasnip.loaders.from_snipmate").lazy_load()

local exorj = ls.expand_or_jumpable
local exj = ls.expand_or_jump

local inoremaps = {
    [",,"] = function()
        if exorj() then
            exj()
        end
    end,
}

apply_keys("n", nnoremaps, { noremap = true })
set_keys("i", inoremaps, { noremap = true, silent = true })

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
]]
