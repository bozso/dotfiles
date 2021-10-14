vim.wo.colorcolumn = "79"

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
   go={'gofmt', 'golint', 'govet', 'gobuild', 'golangci-lint'},
   d={'dls', 'dmd'},
   python={'flake8', 'pylint', 'pyre', 'mypy', 'pyright'},
   typescript={'deno'},
   nim={'nimcheck', 'nimlsp'},
}


local ale_fixers = {
    ['*']= {'remove_trailing_lines', 'trim_whitespace'},
    rust={'rustfmt'},
    go={'gofmt'},
    c={'clang-format', 'clangtidy'},
    cpp={'clang-format', 'clangtidy'},
    python={'black'},
    typescript={'deno'},
}


local globals = {
    noswapfile=true,
    colorscheme = "delek",
    mapleader = " ",
    ale_fix_on_save = 1,
    ale_lint_on_text_changed = 0,
    ale_lint_on_insert_leave = 0,
    ale_completion_autoimport = 1,
    ale_go_golangci_lint_executable = 'golangci-lint',
    ["airline#extensions#ale#enabled"] = 1,
    ale_fixers = ale_fixers,
    ale_linters = ale_linters,
}

apply_dict(vim.g, globals)


local opts = {
    tabstop=4,
    softtabstop=4,
    shiftwidth=4,
    expandtab=true,
    number=true,
}

apply_dict(vim.opt, opts)

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

local function apply_keys(mode, keybinds, extra_opts)
    local key_fn = vim.api.nvim_set_keymap
    for key, val in pairs(keybinds) do
	key_fn(mode, key, val, extra_opts)
    end
end

nnoremaps = {
    ["<leader>f"]=":w<C-j>:FZF<C-j>",
    ["<leader>w"]=":w<C-j>",
    ["<leader>b"]=":w<C-j>:buffer<space>",
    ["<leader>d"]=":ALEDetail<C-j>",
    ["<leader>h"]=":ALEHover<C-j>",
}

apply_keys("n", nnoremaps, {noremap = true})

nmaps = {
    ["<C-k>"]="<Plug>(ale_previous_wrap)",
    ["<C-j>"]="<Plug>(ale_next_wrap)",
}

apply_keys("n", nmaps, {silent = true})
