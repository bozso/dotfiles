local ut = require "utils"
local fmt = string.format

-- stylua: ignore
local format_file_extensions = {
    "c", "h", "cpp", "cc", "cxx", "hpp", "hh", "d", "go", "js", "ts", 
    "rs", "py", "lua", "build_defs",
}

local extensions = {}
ut.add_patterns("*.%s", format_file_extensions, extensions)
table.insert(extensions, "BUILD*")

vim.api.nvim_exec(
    fmt(
        [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost %s FormatWrite
augroup END
]],
        table.concat(extensions, ",")
    ),
    true
)

local clang_format = {
    function()
        return {
            exe = "clang-format",
            args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
            stdin = true,
            -- Run clang-format in cwd of the file.
            cwd = vim.fn.expand "%:p:h",
        }
    end,
}

local dprint = {
    function()
        return {
            exe = "dprint",
            args = { "fmt", vim.api.nvim_buf_get_name(0) },
            stdin = false,
        }
    end,
}

local please = {
    function()
        return {
            exe = "please",
            args = { "format", "-w", vim.api.nvim_buf_get_name(0) },
            stdin = false,
        }
    end,
}

require("formatter").setup {
    filetype = {
        rust = {
            -- Rustfmt
            function()
                return {
                    exe = "rustfmt",
                    args = { "--emit=stdout" },
                    stdin = true,
                }
            end,
        },
        c = clang_format,
        cc = clang_format,
        cpp = clang_format,
        cxx = clang_format,
        h = clang_format,
        hh = clang_format,
        hpp = clang_format,
        hxx = clang_format,

        javascript = dprint,
        typescript = dprint,
        markdown = dprint,
        html = dprint,

        lua = {
            function()
                return {
                    exe = "stylua",
                    args = { "-" },
                    stdin = true,
                }
            end,
        },

        go = {
            function()
                return {
                    exe = "gofmt",
                    stdin = true,
                }
            end,
        },

        bzl = please,
        build_defs = please,

        python = {
            function()
                return {
                    exe = "black",
                    args = { "-" },
                    stdin = true,
                }
            end,
        },
    },
}
