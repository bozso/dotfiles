local ut = require("utils")
local fmt = string.format

local down = path.join("/home", "istvan", "packages", "downloaded")
local tmp = "/tmp"
local M = {}

local function simple_tar(url, downloaded, outdir)
    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, outdir, {strip = 1})
        end,
        bin_path = path.join(to, "bin")
    }
end

local function simple_zip(url, downloaded, outdir)
    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.unzip(ctx, downloaded, outdir)
        end,
        bin_path = path.join(to, "bin")
    }
end

function M.flutter()
    local version = "2.5.3"
    local tarfile = fmt("flutter_linux_%s-stable.tar.xz", version)
    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "flutter", version)
    local url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/%s"

    return {
        version = version,
        download = function(ctx)
            ctx.download(fmt(url, tarfile), downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, {strip = 1})
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
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, {strip = 1})
        end,
        bin_path = path.join(to, "bin")
    }
end

function M.clang()
    local version = "13.0.0"

    -- TODO: make this autodetect
    local os = {
        name = "ubuntu",
        version = "16.04",
    }

    local tarfile = fmt(
        "clang+llvm-%s-x86_64-linux-gnu-%s-%s.tar.xz",
        version, os.name, os.version
    )

    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "clang", version)
    local url = fmt(
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-%s/%s",
        version, tarfile
    )

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, {strip = 1})
        end,
        bin_path = path.join(to, "bin")
    }
end

function M.go()
    local version = "1.17.2"

    -- TODO: make this autodetect
    local tarfile = fmt("go%s.linux-amd64.tar.gz", version)

    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "go", version)
    local url = fmt("https://golang.org/dl/%s", tarfile)

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, {strip = 1})
        end,
        bin_path = path.join(to, "bin")
    }
end

function M.deno()

    local version = "1.15.3"

    -- TODO: make this autodetect
    local zipfile = "deno-x86_64-unknown-linux-gnu.zip"

    local downloaded = path.join(tmp, zipfile)
    local to = path.join(down, "deno", version)
    local url = fmt(
        "https://github.com/denoland/deno/releases/download/v%s/%s",
        version, zipfile
    )

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.unzip(ctx, downloaded, to)
        end,
        bin_path = to,
    }
end

return M
