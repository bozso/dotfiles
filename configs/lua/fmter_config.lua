local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local FORMATTING = methods.internal.FORMATTING

local M = {}

M.dprint = {
    filetypes = { "markdown", "json", "toml" },
    name = "dprint",
    method = FORMATTING,
    generator = h.formatter_factory {
        command = "dprint",
        args = { "fmt", "--stdin", "$FILENAME" },
        command = "dprint",
        to_stdin = true,
    },
}

return M
