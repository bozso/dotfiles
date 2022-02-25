local fmt = string.format
local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local default_severity = {
    ["error"] = vim.lsp.protocol.DiagnosticSeverity.Error,
    ["warning"] = vim.lsp.protocol.DiagnosticSeverity.Warning,
    ["information"] = vim.lsp.protocol.DiagnosticSeverity.Information,
    ["hint"] = vim.lsp.protocol.DiagnosticSeverity.Hint,
}

local M = {}

local DIAGNOSTICS_ON_SAVE = methods.internal.DIAGNOSTICS_ON_SAVE

local function parse_cargo_diag(diag, item)
    local msg = item.message
    local spans = msg.spans
    local curfile = vim.api.nvim_buf_get_name(bufnr)
    -- only publish if those are the current file diagnostics
    if curfile == spans.file_name then
        local sv = severities[msg.level] or severities.warning
        local l_end, l_start = spans.line_end, spans.line_start
        local c_end, c_start = spans.column_end, spans.column_start

        table.insert(diag, {
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

M.cargo_check = {
    name = "cargo_check",
    method = DIAGNOSTICS_ON_SAVE,
    filetypes = { "rust" },
    generator = h.generator_factory {
        command = "cargo",
        args = { "check", "--message-format=json" },
        filetypes = { "rust" },
        from_stderr = false,
        ignore_stderr = true,
        format = "json",
        on_output = function(params)
            local diags = {}

            for _, item in ipairs(params.output) do
                if item.reason == "compiler-message" then
                    parse_cargo_diag(diags, item)
                end
            end
            return diags
        end,
    },
}

return M
