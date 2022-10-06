local Pkg = require "mason-core.package"
local _ = require "mason-core.functional"
local platform = require "mason-core.platform"
local github = require "mason-core.managers.github"
local ut = require "utilities"
local format = string.format

local coalesce, when = _.coalesce, _.when
local is_win = ut.is_win

-- local Lang = Pkg.Lang
-- local Cat = Pkg.Cat

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

M.nvim = Pkg.new {
    name = "neovim",
    desc = "Vim-fork focused on extensibility and usability",
    homepage = "https://neovim.io",
    languages = {},
    categories = {},
    ---@async
    ---@param ctx InstallContext
    install = function(ctx)
        local target = coalesce(
            when(platform.is.mac_arm64, "macos"),
            when(platform.is.linux_x64, "linux64"),
            when(platform.is.win64, "win64")
        )

        local ext = is_win and "zip" or "tar.gz"
        local name = format("nvim-%s", target)

        local opts = {
            -- nvim-linux64.tar.gz
            -- nvim-macos.tar.gz
            -- nvim-win64.msi
            -- nvim-win64.zip
            -- nvim.appimage
            repo = "neovim/neovim",
            asset_file = function(_)
                return format("%s.%s", name, ext)
            end,
        }

        if not is_win then
            opts.strip_prefix = name
        end

        local cmd = is_win and github.unzip_release_file
            or github.untargz_release_file

        local source = cmd(opts)
        source.with_receipt()
        local exe = ut.get_exe "nvim"
        ctx:link_bin("nvim", format("bin/%s", exe))
    end,
}

M.gaze = Pkg.new {
    name = "gaze",
    desc = "Executes commands for you.",
    homepage = "https://github.com/wtetsu/gaze",
    languages = {},
    categories = {},
    ---@async
    ---@param ctx InstallContext
    install = function(ctx)
        local calced_path = nil
        local path = function(version)
            local target = coalesce(
                when(platform.is.mac_arm64, "macos_arm"),
                when(platform.is.mac_x64, "macos_amd"),
                when(platform.is.linux_x64, "linux"),
                when(platform.is.win64, "windows")
            )

            if calced_path == nil then
                calced_path = format("gaze_%s_%s", target, version)
            end
            return calced_path
        end
        local opts = {
            repo = "wtetsu/gaze",
            -- https://github.com/wtetsu/gaze/releases/download/v1.1.2/gaze_linux_v1.1.2.zip
            asset_file = function(version)
                return path(version) .. ".zip"
            end,
        }

        local source = github.unzip_release_file(opts)
        source.with_receipt()
        local exe = is_win and "gaze.exe" or "gaze"
        local exe_path = format("%s/%s", calced_path, exe)
        ctx:link_bin("gaze", exe_path)
    end,
}

return M
