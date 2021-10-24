local function progress(total, current)
    local ratio = current / total;
    ratio = math.min(math.max(ratio, 0), 1);
    local percent = math.floor(ratio * 100);
    print("Download progress (" .. percent .. "%/100%)\r")
end

local function unzip(src, dst)
    zip.extract(src, dst)
end

local function raw_download(src, dst)
    local res, code = http.download(src, dst , {
         progress = progress,
    })

    return res, code
end

local function check_download_exists(src, dst, downloader)
    local res, code

    if not os.isfile(dst) then
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
    download = debug_download,
    execute = debug_execute
}

local normal = {
    unzip = unzip,
    download = checked_down,
    execute = execute
}

if use_debug then
    return debug
else
    return normal
end
