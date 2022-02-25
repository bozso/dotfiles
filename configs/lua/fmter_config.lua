local ut = require "utils"
local fmt = string.format

local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local FORMATTING = methods.internal.FORMATTING

local M = {}

M.dprint = h.generator_factory {
    filetypes = { "markdown", "json", "toml" },
    name = "dprint",
    method = FORMATTING,
    generator_opts = {
        command = "dfmt",
        args = { "fmt", "--stdin", "$FILENAME" },
        command = "dprint",
        to_stdin = true,
    },
    factory = h.formatter_factory,
}

return M
