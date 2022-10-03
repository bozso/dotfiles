local m = {}

local mw = require "mason_wrapper"
local mason = require "mason_setup"

mason.setup()

m.utils = require "packages.utils"
m.compilers = require "packages.compilers"
m.formatters = require "packages.formatters"
m.bt = require "packages.build_tools"
m.web = require "packages.web"

function m.install()
    mw.install {
        { m.utils.so, version = "v0.4.7" },
        { m.utils.gaze, version = "v1.1.2" },
        { m.formatters.dprint, version = "0.30.3" },
        { m.compilers.zig, version = "0.9.1" },
        { m.bt.knit, version = "v0.0.1" },
        { m.web.hugo, version = "v0.102.3" },
        -- TODO: fix these
        -- { pkgs.utils.nvim, version = "v0.7.2" },
        -- { pkgs.compilers.zig, version = "0.9.1" },
    }
end

return m
