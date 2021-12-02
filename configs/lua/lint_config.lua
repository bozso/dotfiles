local lint = require "lint"
local parser = require "lint.parser"
local fmt = string.format

local default_severity = {
    ["error"] = vim.lsp.protocol.DiagnosticSeverity.Error,
    ["warning"] = vim.lsp.protocol.DiagnosticSeverity.Warning,
    ["information"] = vim.lsp.protocol.DiagnosticSeverity.Information,
    ["hint"] = vim.lsp.protocol.DiagnosticSeverity.Hint,
}

local severities = {
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
    refactor = vim.lsp.protocol.DiagnosticSeverity.Information,
    convention = vim.lsp.protocol.DiagnosticSeverity.Hint,
}

local function cargo_check()
    local function parser_impl(output, bufnr)
        if output == "" then
            return {}
        end

        local decoded = vim.fn.json_decode(output)
        local diagnostics = {}

        for _, item in ipairs(decoded) do
            if item.reason == "compiler-message" then
                local msg = item.message
                local spans = msg.spans
                local curfile = vim.api.nvim_buf_get_name(bufnr)
                print(curfile, spans)

                -- only publish if those are the current file diagnostics
                if curfile == spans.file_name then
                    local sv = severities[msg.level] or severities.warning
                    local l_end, l_start = spans.line_end, spans.line_start
                    local c_end, c_start = spans.column_end, spans.column_start

                    table.insert(diagnostics, {
                        range = {
                            ["start"] = {
                                line = l_start - 1,
                                character = c_start - 1,
                            },
                            ["end"] = {
                                line = l_end - 1,
                                character = c_end - 1,
                            },
                        },
                        severity = sv,
                        message = spans.text.text,
                    })
                end
            end
        end
        return diagnostics
    end

    return {
        cmd = "cargo",
        stdin = true,
        args = { "check", "--message-format=json" },
        stream = "stderr",
        ignore_exitcode = false,
        env = nil,
        parser = parser_impl,
    }
end

local function cargo_check_efm()
    -- src/template/service.rs:35:5: warning: field is never read: `context`
    -- path/to/file:line:col: severity: message
    local pattern = "[^:]+:(%d+):(%d+): (%a+): (.+)"
    local groups = { "file", "line", "start_col", "severity", "message" }

    return {
        cmd = "cargo",
        stdin = true,
        args = { "check", "--message-format=short" },
        stream = "stderr",
        ignore_exitcode = false,
        env = nil,
        parser = parser.from_pattern(pattern, groups, default_severity, {
            source = "cargo-check",
        }),
    }
end

lint.linters.cargo_check = cargo_check_efm()

lint.linters_by_ft = {
    go = { "golangcilint" },
    -- rust = { "cargo_check" },
}
