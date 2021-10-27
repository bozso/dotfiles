local ut = require("utils")
local fmt = string.format

local function progress(total, current)
    local ratio = current / total;
    ratio = math.min(math.max(ratio, 0), 1);
    local percent = math.floor(ratio * 100);
    print("Download progress (" .. percent .. "%/100%)\r")
end

local function check_call(format, ...)
    local cmd = fmt(format, ...)
    print(cmd)
    local out, code = os.outputof(cmd)
    if code ~= 0 then
        errorf("executing cmd: '%s', failed (error code: %d): %s",
            cmd, code, out)
    end
end

local function mkdir(dst)
    check_call("mkdir -p \"%s\"", dst)

    local res, err = os.mkdir(dst)
    if not res then
        ut.errorf("failed to create directory: '%s': %s", dst, err)
    end
end

local function needs_update(ctx, dir)
    printf("Checking: '%s'", dir)
    local needs_update = ut.is_dir_empty(dir) or ctx.overwrite

    if needs_update then
        print("Needs update.")
    else
        print("No update needed.")
    end

    return needs_update
end

local function unzip(ctx, src, dst)
    mkdir(dst)
    return zip.extract(src, dst)
end

local function check_before_decompress(ctx, src, dst, decompress)
    if needs_update(ctx, dst) then
        return decompress(ctx, src, dst)
    end
end

local function unzip_check(ctx, src, dst)
    return check_before_decompress(ctx, src, dst, unzip)
end

local function decompress_log(ctx, src, dst, decompress)
    printf("Decompressing file: '%s' to '%s'", src, dst)
    local res = decompress(ctx, src, dst)
    print("Decompression finished.")
    return res
end

local function unzip_debug(ctx, src, dst)
    return decompress_log(ctx, src, dst, unzip_check)
end

local function untar(ctx, src, dst, opts)
    local opts = opts or {}
    local strip = opts.strip or 0

    if needs_update(ctx, dst) then
        mkdir(dst)
        ut.executef(
            ctx, "tar -xvf %s --strip-components=%d -C %s", src, strip,
            dst
        )
    end
end

local function raw_download(src, dst)
    local res, code = http.download(src, dst , {
         progress = progress,
    })
    return res, code
end

-- TODO: get http result codes out of wget command
local function wget(src, dst)
    local dir = path.getdirectory(dst)
    local cmd = fmt("wget %s --directory-prefix=%s", src, dir)
    os.execute(cmd)
end

local function wget_fallback_wrap(src, dst, downloader)
    local res, code = downloader(src, dst)

    if not ut.http.is_okay(code) then
        os.remove(dst)
        wget(src, dst)
    end
end

local function wget_fallback(src, dst)
    return wget_fallback_wrap(src, dst, raw_download)
end

local function check_download_exists(src, dst, downloader)
    local res, code

    if not ut.file_exists(dst) then
        res, code = downloader(src, dst)
    end

    return res, code
end

local function checked_down(src, dst)
    return check_download_exists(src, dst, wget_fallback)
end

local function log_download(src, dst, downloader)
    printf("Downloading from URL: %s", src)
    printf("Destination: %s", dst)
    local red, code = downloader(src, dst)
    printf("Download finished with -- result: %s, code: %s", red, code)

    return res, code
end

function debug_download(src, dst)
    log_download(src, dst, checked_down)
end

local function execute(cmd)
    return os.execute(cmd)
end

local function log_execute(cmd, executor)
    printf("Executing command: %s", cmd)
    local res = executor(cmd)
    printf("Output of command: %s", res)
    return res
end

local function debug_execute(cmd)
    log_execute(cmd, execute)
end

local use_debug = true

local debug = {
    unzip = unzip_debug,
    untar = untar,
    download = debug_download,
    execute = debug_execute
}

local normal = {
    unzip = unzip,
    untar = untar,
    download = checked_down,
    execute = execute,
}

if use_debug then
    return debug
else
    return normal
end
