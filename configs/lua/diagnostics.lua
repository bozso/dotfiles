local null_ls = require "null-ls"
local h = require "null-ls.helpers"
local methods = require "null-ls.methods"
local u = require "null-ls.utils"
local join = u.path.join
local fmt = string.format
local gsub = string.gsub
local find = string.find
local uri_to_buf = vim.uri_to_bufnr
local diag = h.diagnostics

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local severities = {
    error = h.diagnostics.severities["error"],
    warning = h.diagnostics.severities["warning"],
    note = h.diagnostics.severities["information"],
    hint = h.diagnostics.severities["hint"],
}

local M = {}

M.zig = h.make_builtin {
    filetypes = { "zig" },
    name = "zig",
    method = DIAGNOSTICS,
    generator = h.generator_factory {
        check_exit_code = { 0 },
        multiple_files = true,
        command = "zig",
        args = { "build" },
        format = "line",
        from_stderr = true,
        on_output = diag.from_errorformat(
            table.concat({
                "%f:%l:%c: %trror: %m",
                "%f:%l:%c: %tarning: %m",
            }, ","),
            "zig"
        ),
        -- on_output = diag.from_pattern(
        --     [[(%s+):(%d+):(%d+): (%w+): (.*)]],
        --     { "filename", "row", "col", "severity", "message" },
        --     {
        --         severities = {
        --             error = severities.error,
        --         },
        --     }
        -- ),
        -- on_output = diag.from_pattern(
        --     "[^:]+:%d+:%d: (%a+): (.*)",
        --     { "filename", "row", "col", "severity", "message" },
        --     { error = severities.error, warning = severities.warning }
        -- ),
        -- source/slice/raw.d(3,22): Error: undefined identifier `u64`
        -- on_output = h.diagnostics.from_pattern(
        --     "[^:]+(%d+:%d:): (%a+): (.*)",
        --     { "filename", "row", "col", "severity", "message" },
        --     { Error = severities.error }
        -- ),
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

M.dub = h.make_builtin {
    filetypes = { "d" },
    name = "dub",
    method = DIAGNOSTICS,
    generator = h.generator_factory {
        check_exit_code = { 0 },
        multiple_files = true,
        command = "dub",
        args = { "build" },
        format = "line",
        from_stderr = true,
        on_output = diag.from_pattern(
            "[^:]+(%d+:%d:): (%a+): (.*)",
            { "filename", "row", "col", "severity", "message" },
            { Error = severities.error }
        ),
        -- source/slice/raw.d(3,22): Error: undefined identifier `u64`
        -- on_output = h.diagnostics.from_pattern(
        --     "[^:]+(%d+:%d:): (%a+): (.*)",
        --     { "filename", "row", "col", "severity", "message" },
        --     { Error = severities.error }
        -- ),
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

local parser = h.diagnostics.from_json {
    severities = severities,
}

local function clippy_parse_msg(msg)
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
    return message
end

local function parse_children(msg, root, target)
    local chld = msg.children
    local parsed = {}
    sub = chld.children
    if sub and len(sub) ~= 0 then
        parse_children(sub, root, target)
    end
    local msg = clippy_parse_msg(chld)
    table.insert(target, message)
end

local clippy = {
    parsers = {
        old = function(decoded, root, target)
            if
                decoded.message
                and decoded.message.spans
                and decoded.message.spans[1]
                and decoded.message.code
            then
                local msg = clippy_parse_msg(decoded.message)
                table.insert(target, msg)
            end
        end,
        new = function(decoded, root, target)
            if decoded.message then
                local msg = decoded.message
                parse_children(msg, root, target)
            end
        end,
    },
}

local handle_output = function(params)
    local root = params.root
    -- local parser = clippy.parsers.new
    local parser = clippy.parsers.old

    local messages = {}
    for line in string.gmatch(params.output, "[^\n]+") do
        local ok, decoded = pcall(vim.json.decode, line)

        if ok then
            parser(decoded, root, messages)
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
