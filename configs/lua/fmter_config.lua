local ut = require "utils"
local fmt = string.format
local M = {}

-- stylua: ignore
local format_file_extensions = {
    "c", "h", "cpp", "cc", "cxx", "hpp", "hh", "d", "go", "js", "ts", 
    "rs", "py", "lua", "build_defs",
}

local clang = {
    formatCommand = "clang-format --assume-filename=${INPUT}",
    formatStdin = true,
}

local dprint = {
    {
        formatCommand = "dprint fmt --stdin ${INPUT}",
        formatStdin = true,
    },
}

M.languages = {
    lua = {
        {
            formatCommand = "stylua -",
            formatStdin = true,
        },
    },

    python = {
        {
            formatCommand = "blackd-client",
            formatStdin = true,
        },
        {
            lintCommand = "mypy --show-column-numbers --ignore-missing-imports",
            lintSource = "mypy",
            lintFormats = {
                "%f:%l:%c: %trror: %m",
                "%f:%l:%c: %tarning: %m",
                "%f:%l:%c: %tote: %m",
            },
        },
    },

    go = {
        {
            formatCommand = "gofmt",
            formatStdin = true,
        },
    },

    md = dprint,
    markdown = dprint,
    rust = {
        {
            formatCommand = "rustfmt",
            formatStdin = true,
        },
        {
            lintCommand = "cargo clippy",
            lintSource = "cargo",
            lintFormats = { "%f:%l:%c: %m" },
        },
    },
}


-- stylua: ignore
local c_fts = {
    "c", "cc", "cpp", "cxx", "h", "hh", "hpp", "hxx",
}

local c = {
    fmters = {
        ["clang-format"] = function()
            return {
                exe = "clang-format",
                args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
                stdin = true,
                -- Run clang-format in cwd of the file.
                cwd = vim.fn.expand "%:p:h",
            }
        end,
    },
    filetypes = c_fts,
}

local web = {
    fmters = {
        dprint = function()
            return {
                exe = "dprint",
                args = { "fmt", vim.api.nvim_buf_get_name(0) },
                stdin = false,
            }
        end,
    },
    filetypes = {
        "javascript",
        "typescript",
        "markdown",
        "toml",
    },
}

local please = {
    fmters = {
        please = function()
            return {
                exe = "please",
                args = { "format", "-w", vim.api.nvim_buf_get_name(0) },
                stdin = false,
            }
        end,
    },
    filetypes = { "build_defs", "bzl" },
}

local rust = {
    fmters = {
        rustfmt = function()
            return {
                exe = "rustfmt",
                args = { "--emit=stdout" },
                stdin = true,
            }
        end,
    },
    filetypes = { "rust" },
}

local lua = {
    fmters = {
        stylua = function()
            return {
                exe = "stylua",
                args = { "-" },
                stdin = true,
            }
        end,
    },
    filetypes = { "lua" },
}

local function add_fmter(fmter, fts, to)
    for _, ft in pairs(fts) do
        to[ft] = fmter
    end
end

local function setup(fmter_setups)
    local is_exec = vim.fn.executable
    local filetype = {}

    for _, setup in pairs(fmter_setups) do
        for key, fmter in pairs(setup.fmters) do
            local curr = {}
            if is_exec(key) ~= 0 then
                table.insert(curr, fmter)
            end
            if #curr > 0 then
                for _, ft in pairs(setup.filetypes) do
                    filetype[ft] = curr
                end
            end
        end
    end
    return filetype
end

local filetype = setup {
    c,
    web,
    please,
    rust,
    lua,
}

local ft_to_ext = {
    javascript = "js",
    typescript = "ts",
    markdown = "md",
    python = "py",
}

local file_extensions = {}

for ft, _ in pairs(filetype) do
    local ext = ft
    local maybe_ext = ft_to_ext[ft]
    if maybe_ext ~= nil then
        ext = maybe_ext
    end
    table.insert(file_extensions, ext)
end

local extensions = {}
ut.add_patterns("*.%s", file_extensions, extensions)
table.insert(extensions, "BUILD*")

-- vim.api.nvim_exec(
--     [[
-- augroup FormatAutogroup
--   autocmd!
--   autocmd BufWritePost <cmd>lua vim.lsp.buf.formatting()<cr><cmd>w<cr>
-- augroup END
-- ]],
--     true
-- )

require("formatter").setup {
    filetype = filetype,
}

return M
