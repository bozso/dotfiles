local Pkg = require "mason-core.package"
local fetch = require "mason-core.fetch"
local _ = require "mason-core.functional"
local platform = require "mason-core.platform"
local github = require "mason-core.managers.github"
local format = string.format
local std = require "mason-core.managers.std"

local coalesce, when, pis = _.coalesce, _.when, platform.is
local ut = require "utilities"
local interp = ut.interp
local is_win = ut.is_win

local M = {}

local Lang = Pkg.Lang
local Cat = Pkg.Cat

-- TODO: finish configuration
M.clang = Pkg.new {
    name = "clang",
    desc = _.dedent [[
        The Clang project provides a language front-end and tooling infrastructure
        for languages in the C language family (C, C++, Objective C/C++,
        OpenCL, CUDA, and RenderScript) for the LLVM project. Both a
        GCC-compatible compiler driver (clang) and an MSVC-compatible compiler 
        driver (clang-cl.exe) are provided.
    ]],
    homepage = "https://clang.llvm.org/",
    languages = { Lang.C, Lang["C++"] },
    categories = { Cat.Compiler },
    ---@async
    ---@param ctx InstallContext
    install = function(ctx)
        local fmt = coalesce(
            when(pis.linux, "clang+llvm-${version}-${arch}-linux-${clib}-${os}"),
            when(pis.freebsd, "clang+llvm-${version}-${arch}-unknown-${os}")
        )

        local arch =
        coalesce(when(pis.mac_x64, "x86_64"), when(pis.linux_x64, "x86_64"))
        local clib = platform.get_libc()

        local opts = {
            repo = "llvm/llvm-project",
            asset_file = function(version)
                return interp(fmt, {
                    version = version,
                    arch = arch,
                    os = os,
                    clib = clib,
                })
            end,
        }

        local source = github.untarxz_release_file(opts)
        source.with_receipt()
        -- ctx:link_bin("so", exe)
    end,
}

-- @param cfg table
M.zig = function(version)
    return Pkg.new {
        name = "zig",
        desc = _.dedent [[
            Zig is a general-purpose programming language and toolchain for
            maintaining robust, optimal and reusable software.
        ]],
        homepage = "https://ziglang.org/",
        languages = { Lang.Zig, Lang.zig },
        categories = { Cat.Compiler },
        ---@async
        ---@param ctx InstallContext
        --
        -- return {
        --     "name": "zig",
        --     "exported_files": [],
        --     "url": "https://ziglang.org/download/%s/zig-%s-x86_64-%s.tar.xz" % (
        --         version,
        --         CONFIG.OS,
        --         version,
        --     ),
        --     "out": "zig/v%s" % version,
        --     "strip_prefix": "zig-%s-x86_64-%s" % (CONFIG.OS, version),
        --     "bin": "zig/v%s" % version,
        --
        --     zig-linux-x86_64-0.9.1.tar.xz
        --     zig-linux-i386-0.9.1.tar.xz
        --     zig-linux-riscv64-0.9.1.tar.xz
        --     zig-linux-aarch64-0.9.1.tar.xz
        --     zig-linux-armv7a-0.9.1.tar.xz
        --     zig-macos-x86_64-0.9.1.tar.xz
        --     zig-macos-aarch64-0.9.1.tar.xz
        --     zig-windows-x86_64-0.9.1.zip
        --     zig-windows-i386-0.9.1.zip
        --     zig-windows-aarch64-0.9.1.zip
        --     zig-freebsd-x86_64-0.9.1.tar.xz
        -- }
        install = function(ctx)
            local tpl = coalesce(
                when(pis.mac_arm64, "macos-aarch64"),
                when(pis.mac_x64, "macos-x86_64"),
                when(pis.linux_arm64, "linux-aarch64"),
                when(pis.linux_x64, "linux-x86_64"),
                when(pis.linux_i386, "linux-i386"),
                when(pis.linux_aarch64, "linux-aarch64"),
                when(pis.win_i386, "windows-i386"),
                when(pis.win_x64, "windows-x86_64"),
                when(pis.win_aarch64, "windows-aarch64"),
                when(pis.freebsd_x64, "freebsd-x86_64")
            )

            local ext = pis.is_win and "zip" or "tar.xz"
            local name = ("zig-%s-%s"):format(tpl, version)
            local url = ("https://ziglang.org/download/%s/%s.%s"):format(
                version,
                name,
                ext
            )
            ctx.stdio_sink.stdout(format("zig url: %s", url))

            local out_file = ("archive.%s"):format(ext)
            std.download_file(url, out_file)
            -- fetch(url, { out_file = out_file }):get_or_throw "Download failed"
            local cmd = ut.is_win and std.unzip or std.untarxz

            local second = is_win and "." or { strip_components = name }

            cmd(out_file, second)

            local exe = ut.get_exe "zig"
            ctx:link_bin("zig", exe)
        end,
    }
end

return M
