local M = {}

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

M.update_table = update_table

return M
