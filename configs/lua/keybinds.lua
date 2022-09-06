local M = {}

---@enum Mode
M.Mode = {
    insert = 0,
    normar = 1,
}

---@class Leader
---@field key string
M.Leader = {}

---@alias Keybinds table<string | Leader, function | string>

---@alias All table<Mode, Keybinds>

return M
