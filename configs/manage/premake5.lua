local pkgs = require("packages")
local pm = require("premake_manage")
local fmt = string.format

local function get_paths(pkgs)
    local paths = {}
    for key, desc in pairs(pkgs) do
        local pkg = desc()
        local pth = pkg.bin_path
        if pth ~= nil then
            table.insert(paths, pth)
        end
    end
    return paths
end

local function join_paths(pkgs, sep)
    local paths = get_paths(pkgs)
    return table.concat(paths, sep)
end

local function run(pkgs, ctx)
    for key, desc in pairs(pkgs) do
        local pkg = desc()
        pkg.download(ctx)
        pkg.decompress(ctx)
    end
end

newaction {
    trigger = "all",
    description = "Run all steps required for installation.",
    execute = function()
        local ctx = pm
        ctx.overwrite = false
        if _OPTIONS["overwrite"] then
            ctx.overwrite = true
        end
        local res, err = pcall(run, pkgs, ctx)
        if not res then
            printf(
                "Error, while running all installation steps: %s",
                tostring(err)
            )
        end
    end
}

newaction {
    trigger = "bin_paths",
    description = "List paths to directories holding binary files.",
    execute = function()
        print(join_paths(pkgs, "\n"))
    end
}

newaction {
    trigger = "gen_path",
    description = "Generate PATH variable.",
    execute = function()
        io.writefile(
            _OPTIONS["path"],
            fmt("export PATH=${PATH}:%s", join_paths(pkgs, ":"))
        )
    end
}

newoption {
    trigger = "path",
    description = "Path to generated shell script file.",
    value = "string",
}

newoption {
    trigger = "overwrite",
    description = "Set it to overwrite existing files."
}
