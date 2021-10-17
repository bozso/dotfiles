local fmt = string.format

local function update_table(opts)
    local to = opts.to
    local groups = opts.groups

    if groups ~= nil then
        for name, opts in pairs(groups) do
            for key, val in pairs(opts) do
                to[name .. key] = val
            end
        end
    end

    for key, opt in pairs(opts) do
        if key ~= "groups" and key ~= "to" then
            to[key] = opt
        end
    end
end


local function apply_dict(dict, options)
    for key, opt in pairs(options) do
        dict[key] = opt
    end
end

local function add_patterns(tpl, iter, to)
    for _, ext in pairs(iter) do
        table.insert(to, fmt(tpl, ext))
    end
end

local function ignored_patterns(opts)
    local ignores = {}
    for tpl, iter in pairs(opts) do
        add_patterns(tpl, iter, ignores)
    end
    return ignores
end

return {
    update_table = update_table,
    ignored_patterns = ignored_patterns,
}
