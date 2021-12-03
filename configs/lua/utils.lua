local M = {}
local fmt = string.format

function M.update_table(opts)
    local to = opts.to
    local groups = opts.groups
    local options = opts.options

    if groups ~= nil then
        for name, opts in pairs(groups) do
            for key, val in pairs(opts) do
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

local function apply_dict(dict, options)
    for key, opt in pairs(options) do
        dict[key] = opt
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
