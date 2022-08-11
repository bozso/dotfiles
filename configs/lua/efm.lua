local M = {}

-- /home/istvan/packages/src/sr.ht/pygeo/src/build.zig:44:17: error: use of undeclared identifier 'root'
M.zig = {
    {
        lintCommand = "zig build",
        lintFormats = {
            "%f:%l:%c: %rror: %m",
        },
    },
}

return M
