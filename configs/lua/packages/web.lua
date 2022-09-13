local Pkg = require "mason-core.package"
-- local fetch = require "mason-core.fetch"
local _ = require "mason-core.functional"
local platform = require "mason-core.platform"
local github = require "mason-core.managers.github"
-- local format = string.format
-- local std = require "mason-core.managers.std"

local coalesce, when, pis = _.coalesce, _.when, platform.is
local ut = require "utilities"
local interp = ut.interp
local is_win = ut.is_win

local M = {}

local Lang = Pkg.Lang
-- local Cat = Pkg.Cat

M.hugo = Pkg.new {
    name = "hugo",
    desc = "The world’s fastest framework for building websites.",
    homepage = "https://gohugo.io/",
    languages = { Lang.html, Lang.js, Lang.css, Lang.javascript },
    categories = {},
    ---@async
    ---@param ctx InstallContext
    install = function(ctx)
        local target = coalesce(
            when(platform.is.mac, "macOS-universal"),
            when(platform.is.linux_arm64, "Linux-ARM64"),
            when(platform.is.linux_x64, "Linux-64bit"),
            when(platform.is.win_arm64, "Windows-ARM64"),
            when(platform.is.win_x64, "Windows-64bit")
        )

        local fmt = "hugo_${version}_${target}.${extension}"

        local ext = is_win and "zip" or "tar.gz"

        local opts = {
            repo = "gohugoio/hugo",
            asset_file = function(version)
                local file = interp(fmt, {
                    version = version:gsub("v", ""),
                    target = target,
                    extension = ext,
                })
                print(file)
                return file
            end,
        }

        local cmd = ut.is_win and github.unzip_release_file
            or github.untargz_release_file
        -- local second = is_win and "." or { strip_components = name }

        local source = cmd(opts)
        source.with_receipt()

        local exe = ut.get_exe "hugo"
        ctx:link_bin("hugo", exe)
    end,
}

return M
