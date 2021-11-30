local lint = require "lint"
local parser = require "lint.parser"
local fmt = string.format

local function cargo_check()
    -- src/handle/ops.rs:53:38: warning: variable does not need to be mutable
    local tpl = "%%f:%%l:%%c: %s: %%m"

    local efm = table.concat({
        fmt(tpl, "%trror"),
        fmt(tpl, "%tarning"),
        fmt(tpl, "%tnfo"),
    }, ", ")

    return {
        cmd = "cargo",
        stdin = true,
        args = { "check", "--message-format=short" },
        stream = "stderr",
        ignore_exitcode = false,
        env = nil,
        parser = parser.from_errorformat(efm),
    }
end

lint.linters.cargo_check = cargo_check()

lint.linters_by_ft = {
    go = { "golangcilint" },
    -- rust = { "cargo_check" },
}
