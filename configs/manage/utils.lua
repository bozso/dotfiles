local M = {}
local fmt = string.format

local http = {
    ok = 200,
}

function M.errorf(format, ...)
    error(fmt(format, ...))
end

function http.is_okay(code)
    return code == http.ok
end

function http.check(res, code)
    if http.is_okay(code) then
        M.errorf("got not okay http status (%d) with message: %s", code, res)
    end
end

function M.executef(ctx, format, ...)
    local str = fmt(format, ...)
    return ctx.execute(str)
end

local function pattern_matched(num)
    if num ~= nil then
        return num > 0
    end
    return false
end

function M.is_dir_empty(pth)
    local ret = true

    nfiles = #os.matchfiles(path.join(pth, "**"))
    ndirs = #os.matchdirs(path.join(pth, "**"))

    if pattern_matched(ndirs) or pattern_matched(nfiles) then
        ret = false
    end

    return ret
end

function M.file_exists(filepath, opts)
    local isfile = false
    local not_empty = true
    local opts = opts or {}
    local check_not_empty = opts.check_not_empty or true

    local stat = os.stat(filepath)
    if stat == nil then
        return false
    end

    if check_not_empty then
        return stat.size > 0
    end

    return true
end

function M.untar(ctx, src, dst, opts)
    local strip = opts.strip or 0

    if not M.is_dir_empty(dst) or ctx.overwrite then
        os.mkdir(dst)
        M.executef(
            ctx,
            "tar -xvf %s --strip-components=%d -C %s",
            src,
            strip,
            dst
        )
    end
end

M.http = http

return M
