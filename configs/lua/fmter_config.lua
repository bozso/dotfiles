require "import"

local M = {}

local function setup()
    local h = require "null_ls.helpers"
    local methods = require "null_ls.helpers"
    local FORMATTING = methods.internal.FORMATTING
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
end

-- import({ "null-ls.helpers", "null-ls.methods" }, setup)

return M
