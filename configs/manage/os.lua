local ut = require("utils")
local M = {}

local function Enum(dict)
    local d = {
        names = function(self)
            names = {}
            for key, _ in pairs(self) do
                table.insert(names, key)
            end
            return names
        end,

        join_names = function(self, sep)
            return table.concat(self:names(), ", ")
        end,

        from_str = function(self, str)
            for key, val in pairs(self.key_vals) do
                if str == key then
                    return val
                end
            end
            return nil
        end,

        key_vals = dict,
    }

    setmetatable(d, {
        __index = dict,
    })

    return d
end

M.system = Enum {
    aix = 0,
    bsd = 1,
    haiku = 2,
    linux = 3,
    macosx = 4,
    solaris = 5,
    wii = 6,
    windows = 7,
    xbox360 = 8
}

print(M.system:join_names("," ))
print(M.system.linux)
print(M.system:from_str("linux"))
error("stop")


function str_to_enum_val(str, enum)
end

function M.get_system_info()
    return {
    }
end

return M