local ut = require("utils")
local fmt = string.format

local down = path.join("/home", "istvan", "packages", "downloaded")
local tmp = "/tmp"
local M = {}


-- dm_flutter() {
--     set -euo pipefail
--     local here="$(pwd)"
--
--     cd /tmp
--     wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${flutter_tarfile}"
--     tar -xvf "${flutter_tarfile}"
--     mkdir -p "${flutter_to}"
--     mv flutter/{.,}* "${flutter_to}"
--     cd "${here}"
-- }

function M.flutter()
    local version = "2.5.3"
    local tarfile = fmt("flutter_linux_%s-stable.tar.xz", version)
    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "flutter", version)
    local url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/%s"

    return {
        version = version,
        bin = bin,
        download = function(ctx)
            ctx.download(fmt(url, tarfile), downloaded)
        end,
        unzip = function(ctx)
            ut.untar(ctx, downloaded, to, {strip = 1})
        end,
        bin_path = path.join(to, "bin")
    }
end

function M.node()
    local version = "14.18.1"
    local tarfile = fmt("node-v%s-linux-x64.tar.xz", version)
    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "node", version)
    local url = fmt(
        "https://nodejs.org/dist/v%s/%s", version, tarfile
    )

    return {
        version = version,
        bin = bin,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        unzip = function(ctx)
            ut.untar(ctx, downloaded, to, {strip = 1})
        end,
        bin_path = path.join(to, "bin")
    }
end

return M
