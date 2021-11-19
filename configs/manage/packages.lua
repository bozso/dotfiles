local ut = require "utils"
local fmt = string.format

local down

if false then
    down = path.join("/quanta1", "home", "istvan", "packages", "downloaded")
else
    down = path.join("/home", "istvan", "packages", "downloaded")
end

local tmp = path.join("/tmp", "download_cache")
os.mkdir(tmp)

local M = {}

local function simple_tar(opts)
    return {
        version = opts.version,
        download = function(ctx)
            ctx.download(opts.url, opts.downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, opts.downloaded, opts.dir, { strip = 1 })
        end,
        dir = opts.dir,
        bin_path = opts.bin,
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
        bin_path = path.join(to, "bin"),
    }
end

function M.flutter()
    local version = "2.5.3"
    local tarfile = fmt("flutter_linux_%s-stable.tar.xz", version)
    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "flutter", version)
    local url =
        "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/%s"

    return {
        version = version,
        download = function(ctx)
            ctx.download(fmt(url, tarfile), downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, { strip = 1 })
        end,
        dir = to,
        bin_path = path.join(to, "bin"),
    }
end

function M.node()
    local version = "14.18.1"
    local tarfile = fmt("node-v%s-linux-x64.tar.xz", version)
    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "node", version)
    local url = fmt("https://nodejs.org/dist/v%s/%s", version, tarfile)

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, { strip = 1 })
        end,
        dir = to,
        bin_path = path.join(to, "bin"),
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
        version,
        os.name,
        os.version
    )

    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "clang", version)
    local url = fmt(
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-%s/%s",
        version,
        tarfile
    )

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, { strip = 1 })
        end,
        dir = to,
        bin_path = path.join(to, "bin"),
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
            ctx.untar(ctx, downloaded, to, { strip = 1 })
        end,
        dir = to,
        bin_path = path.join(to, "bin"),
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
        version,
        zipfile
    )

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.unzip(ctx, downloaded, to)
        end,
        dir = to,
        bin_path = to,
    }
end

function M.ra()
    local version = "2021-11-01"

    -- TODO: make this autodetect
    local tarfile = "rust-analyzer-x86_64-unknown-linux-gnu.gz"

    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "rust_analyzer", version)
    local url = fmt(
        "https://github.com/rust-analyzer/rust-analyzer/releases/download/%s/%s",
        version,
        tarfile
    )

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.gzip(ctx, downloaded, to)
        end,
        dir = to,
        bin_path = path.join(to, "bin"),
    }
end

function M.nim()
    local version = "1.6.0"

    -- TODO: make this autodetect
    local tarfile = fmt("nim-%s-linux_x64.tar.xz", version)

    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "nim", version)
    local url = "https://nim-lang.org/download/" .. tarfile

    return {
        version = version,
        download = function(ctx)
            ctx.download(url, downloaded)
        end,
        decompress = function(ctx)
            ctx.untar(ctx, downloaded, to, { strip = 1 })
        end,
        dir = to,
        bin_path = path.join(to, "bin"),
    }
end

function M.efm_langserver()
    local version = "0.0.37"

    -- TODO: make this autodetect
    local tarfile = fmt("efm-langserver_v%s_linux_amd64.tar.gz", version)

    local downloaded = path.join(tmp, tarfile)
    local to = path.join(down, "efm_langserver", version)
    local url = fmt(
        "https://github.com/mattn/efm-langserver/releases/download/v%s/%s",
        version,
        tarfile
    )

    return simple_tar {
        version = version,
        url = url,
        downloaded = downloaded,
        dir = to,
        bin = to,
    }
end

return M
