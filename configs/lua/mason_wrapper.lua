local M = {}

-- taken from https://raw.githubusercontent.com/WhoIsSethDaniel/mason-tool-installer.nvim/e2bb024f50dcbf2d9a0e0520c1cce6d734984f9f/lua/mason-tool-installer/init.lua
local show = function(msg)
    vim.schedule_wrap(print(string.format("[mason-tool-installer] %s", msg)))
end

local show_error = function(msg)
    vim.schedule_wrap(
        vim.api.nvim_err_writeln(
            string.format("[mason-tool-installer] %s", msg)
        )
    )
end

-- @param p Pkg
-- @param version string
local function do_install(p, version)
    if version ~= nil then
        show(string.format("%s: updating to %s", p.name, version))
    else
        show(string.format("%s: installing", p.name))
    end
    p:once("install:success", function()
        show(string.format("%s: successfully installed", p.name))
    end)
    p:once("install:failed", function()
        show_error(string.format("%s: failed to install", p.name))
    end)
    p:install { version = version }
end

-- @param p Pkg
-- @param version string
local function install_one(p, version)
    if p:is_installed() and version ~= nil then
        p:get_installed_version(function(ok, installed_version)
            if ok and installed_version ~= version then
                do_install(p, version)
            end
        end)
    else
        do_install(p, version)
    end
end

function M.install(tbl)
    for _, item in ipairs(tbl) do
        local p, version
        if type(item) == "table" then
            p = item[1]
            version = item.version
        else
            p = item
        end
        install_one(p, version)
    end
end

return M
