local ut = require("utils")
local fmt = string.format

local format_file_extensions = {
    "c", "cpp", "cc", "cxx", "d", "py", "go", "js", "ts", "rs",
}

local extensions = {}
ut.add_patterns("*.%s", format_file_extensions, extensions)

vim.api.nvim_exec(fmt([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost %s FormatWrite
augroup END
]], table.concat(extensions, ",")), true)


local clang_format = {
    function()
        return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            -- Run clang-format in cwd of the file.
            cwd = vim.fn.expand('%:p:h')
        }
    end
}

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
        c = clang_format,
        cc = clang_format,
        cpp = clang_format,
        go = {
            function()
                return {
                    exe = "gofmt",
                    stdin = true,
                }
            end
        }
    }
}
