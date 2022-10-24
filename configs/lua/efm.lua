local M = {}

-- local linters = require "efmls-configs.linters"

-- /home/istvan/packages/src/sr.ht/pygeo/src/build.zig:44:17: error: use of undeclared identifier 'root'
M.zig = {
    {
        lintCommand = "zig build",
        lintFormats = {
            "%f:%l:%c: %rror: %m",
        },
    },
}

local linter = "dmd"
local command = string.format("%s -color=off -vcolumns -o- -wi -c -", linter)

M.dmd = {
    prefix = linter,
    lintCommand = command,
    lintStdin = true,
    lintFormats = { "%.%#(%l,%c): %trror: %m", "%.%#(%l,%c): %tarning: %m" },
    rootMarkers = {},
}

return M
