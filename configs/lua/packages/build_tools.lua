local Pkg = require "mason-core.package"
local go = require "mason-core.managers.go"
-- local _ = require "mason-core.functional"
-- local platform = require "mason-core.platform"
-- local github = require "mason-core.managers.github"
-- local ut = require "utilities"
-- local format = string.format

-- local coalesce, when = _.coalesce, _.when
-- local is_win = ut.is_win

local Lang = Pkg.Lang
-- local Cat = Pkg.Cat

local M = {}

M.knit = Pkg.new {
    name = "knit",
    desc = "A smart and powerful build tool using Lua, inspired by make/mk.",
    homepage = "https://github.com/zyedidia/knit",
    languages = { Lang.C, Lang["C++"], Lang.Go },
    categories = {},
    -- install = go.packages { "github.com/zyedidia/knit", bin = { "efm-langserver" } },
    install = go.packages {
        "github.com/zyedidia/knit/cmd/knit",
        bin = { "knit" },
    },
}

return M
