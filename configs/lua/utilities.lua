local M = {}
local fmt = string.format

-- @param s string
-- @param tab table<string, any>
function M.interp(s, tab)
    return s:gsub("($%b{})", function(w)
        return tab[w:sub(3, -2)] or w
    end)
end

function M.update_table(opts)
    local to = opts.to
    local groups = opts.groups
    local options = opts.options

    if groups ~= nil then
        for name, lopts in pairs(groups) do
            for key, val in pairs(lopts) do
                to[name .. key] = val
            end
        end
    end

    if options ~= nil then
        for key, opt in pairs(options) do
            to[key] = opt
        end
    end
end

function M.add_patterns(tpl, iter, to)
    for _, ext in pairs(iter) do
        table.insert(to, fmt(tpl, ext))
    end
end

function M.ignored_patterns(opts)
    local ignores = {}
    for tpl, iter in pairs(opts) do
        M.add_patterns(tpl, iter, ignores)
    end
    return ignores
end

function M.format()
    vim.lsp.buf.formatting_seq_sync()
end

return M
