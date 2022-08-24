local Pkg = require "mason-core.package"
local _ = require "mason-core.functional"
local platform = require "mason-core.platform"
local github = require "mason-core.managers.github"
local ut = require "utilities"
local format = string.format
local std = require "mason-core.managers.std"

local coalesce, when = _.coalesce, _.when
local is_win = ut.is_win

local Lang = Pkg.Lang
local Cat = Pkg.Cat

local M = {}

M.dprint = Pkg.new {
    name = "dprint",
    desc = "Pluggable and configurable code formatting platform written in Rust.",
    homepage = "https://dprint.dev/",
    languages = { Lang.js, Lang.json, Lang.ts, Lang.markdown, Lang.md },
    categories = { Cat.Formatter },
    ---@async
    ---@param ctx InstallContext
    install = function(ctx)
        -- dprint-aarch64-apple-darwin.zip
        -- dprint-x86_64-apple-darwin.zip
        -- dprint-x86_64-pc-windows-msvc.zip
        -- dprint-aarch64-unknown-linux-gnu.zip
        -- dprint-x86_64-unknown-linux-gnu.zip

        local target = coalesce(
            when(platform.is.mac_x64, "x86_64-apple-darwin"),
            when(platform.is.mac_arm64, "aarch64-apple-darwin"),
            when(platform.is.linux_arm64, "aarch64-unknown-linux-gnu"),
            when(platform.is.linux_x64, "x86_64-unknown-linux-gnu"),
            when(platform.is.win_x64, "x86_64-pc-windows-mscv")
        )

        local source = github.release_file {
            repo = "dprint/dprint",
            asset_file = format("dprint-%s.zip", target),
        }
        source.with_receipt()

        local outfile = "dprint.zip"
        std.download_file(source.download_url, outfile)

        std.unzip(outfile, ".")

        local exe = ut.get_exe "dprint"
        ctx:link_bin("dprint", exe)
    end,
}

return M
