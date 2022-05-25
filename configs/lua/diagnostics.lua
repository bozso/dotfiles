local null_ls = require "null-ls"
local h = require "null-ls.helpers"
local methods = require "null-ls.methods"
local u = require "null-ls.utils"
local join = u.path.join
local fmt = string.format
local gsub = string.gsub
local find = string.find
local uri_to_buf = vim.uri_to_bufnr

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local M = {}

M.dub = {
    filetypes = { "d" },
    name = "dub",
    method = DIAGNOSTICS,

    generator = h.generator_factory {
        command = "dub",
        args = { "build" },
        format = "line",
        from_stderr = true,
        on_output = h.diagnostics.from_pattern {
            "[^:]+(%d+:%d:): (%a+) (.*)",
            { "filename", "row", "col", "severity", "message" },
        },
        -- on_output = h.diagnostics.from_errorformat {
        --     table.concat({
        --         "%f(%l,%c): %trror: %m",
        --         "%f(%l,%c): %tarning: %m",
        --         "%f(%l,%c): %teprecation: %m",
        --         "%f(%l,%c): %m",
        --     }, ","),
        --     "dub",
        -- },
        -- check_exit_code, -- function or table of numbers (optional)
        -- env, -- table (optional)
        -- cwd, -- function (optional)
        -- dynamic_command, -- function (optional)
        -- ignore_stderr, -- boolean (optional)
        -- multiple_files, -- boolean (optional)
        -- timeout, -- number (optional)
        -- to_stdin, -- boolean (optional)
        -- to_temp_file, -- boolean (optional)
        -- use_cache, -- boolean (optional)
    },
}

local DIAGNOSTICS = methods.internal.DIAGNOSTICS
local severities = {
    error = h.diagnostics.severities["error"],
    warning = h.diagnostics.severities["warning"],
    note = h.diagnostics.severities["information"],
    hint = h.diagnostics.severities["hint"],
}

local parser = h.diagnostics.from_json {
    severities = severities,
}

local handle_output = function(params)
    local l = require "null-ls.logger"
    local root = params.root

    local messages = {}
    for line in string.gmatch(params.output, "[^\n]+") do
        local ok, decoded = pcall(vim.json.decode, line)

        if
            ok
            and decoded.message
            and decoded.message.spans
            and decoded.message.spans[1]
            and decoded.message.code
        then
            local msg = decoded.message
            local span = msg.spans[1]
            local file_name = span.file_name
            local stripped_src = gsub(file_name, "src", "")
            local bufname = join(root, stripped_src)
            local bufnr = uri_to_buf("file:///" .. bufname)

            local message = {
                row = span.line_start,
                col = span.column_start,
                end_row = span.line_end,
                end_col = span.column_end,
                severity = severities[msg.level],
                message = msg.rendered,
                filename = bufname,
                bufnr = bufnr,
            }
            table.insert(messages, message)
        end
    end

    return messages
end

M.clippy = h.make_builtin {
    name = "clippy",
    method = DIAGNOSTICS,
    filetypes = { "rust" },
    generator = h.generator_factory {
        command = "cargo",
        format = "json_raw",
        args = { "clippy", "--frozen", "--message-format=json", "-q", "--" },
        check_exit_code = { 0 },
        on_output = handle_output,
        multiple_files = true,
    },
}

return M
