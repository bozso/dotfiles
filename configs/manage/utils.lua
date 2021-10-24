local M = {}
local fmt = string.format

function M.executef(ctx, format, ...)
    local str = fmt(format, ...)
    return ctx.execute(str)
end

local function is_dir_empty(pth)
    local ret = false

    nfiles = #os.matchfiles(path.join(pth, "*"))
    if nfiles > 0 then
        ret = true
    end

    return ret
end

function M.untar(ctx, src, dst, opts)
    local strip = opts.strip or 0

    if not is_dir_empty(dst) or ctx.overwrite then
        os.mkdir(dst)
        M.executef(
            ctx, "tar -xvf %s --strip-components=%d -C %s", src, strip,
            dst
        )
    end
end

return M
