local ut = require("utils")

local function progress(total, current)
    local ratio = current / total;
    ratio = math.min(math.max(ratio, 0), 1);
    local percent = math.floor(ratio * 100);
    print("Download progress (" .. percent .. "%/100%)\r")
end

local function needs_update(ctx, dir)
    return not ut.is_dir_empty(dst) or ctx.overwrite
end

local function unzip(ctx, src, dst)
    if needs_update(ctx, dst) then
        return zip.extract(src, dst)
    end
end

local function untar(ctx, src, dst, opts)
    local opts = opts or {}
    local strip = opts.strip or 0

    if needs_update(ctx, dst) then
        os.mkdir(dst)
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
    ut.check_http(res, code)

    return res, code
end

local function check_download_exists(src, dst, downloader)
    local res, code

    if not ut.file_exists(dst) then
        res, code = downloader(src, dst)
    end

    return res, code
end

local function checked_down(src, dst)
    return check_download_exists(src, dst, raw_download)
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
    unzip = unzip,
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
