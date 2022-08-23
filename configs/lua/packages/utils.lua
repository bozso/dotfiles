local Pkg = require "mason-core.package"
local _ = require "mason-core.functional"
local platform = require "mason-core.platform"
local github = require "mason-core.managers.github"

local coalesce, when = _.coalesce, _.when

local M = {}
M.so = Pkg.new {
    name = "so",
    desc = "A terminal interface for Stack Overflow",
    homepage = "https://github.com/samtay/so",
    languages = {},
    categories = {},
    ---@async
    ---@param ctx InstallContext
    install = function(ctx)
        local is_win = platform.is.win
        local opts = {
            repo = "samtay/so",
            asset_file = function(_)
                local target = coalesce(
                    when(
                        platform.is.mac_arm64,
                        "so-aarch64-apple-darwin.tar.gz"
                    ),
                    when(
                        platform.is.linux_arm64,
                        "so-aarch64-unknown-linux-gnu.tar.gz"
                    ),
                    when(
                        platform.is.linux_x64,
                        "so-x86_64-unknown-linux-gnu.tar.gz"
                    ),
                    when(
                        platform.is.linux_x64,
                        "so-x86_64-unknown-linux-musl.tar.gz"
                    )
                )
                return target
            end,
        }

        local cmd = is_win and github.unzip_release_file
            or github.untargz_release_file

        local source = cmd(opts)
        source.with_receipt()
        local exe = is_win and "so.exe" or "so"
        ctx:link_bin("so", exe)
    end,
}

return M
