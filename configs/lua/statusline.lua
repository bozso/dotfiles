require "import"

import("mini.statusline", function(ms)
    local function active()
        local mode, mode_hl = ms.section_mode { trunc_width = 120 }
        local git = ms.section_git { trunc_width = 75 }
        -- local diagnostics = ms.section_diagnostics { trunc_width = 75 }
        local filename = ms.section_filename { trunc_width = 140 }
        local fileinfo = ms.section_fileinfo { trunc_width = 120 }
        local location = ms.section_location { trunc_width = 75 }

        return ms.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = "msDevinfo", strings = { git } },
            "%<", -- Mark general truncate point
            { hl = "msFilename", strings = { filename } },
            "%=", -- End left alignment
            { hl = "msFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { location } },
        }
    end

    ms.setup {
        -- Content of statusline as functions which return statusline string. See `:h
        -- statusline` and code of default contents (used when `nil` is supplied).
        content = {
            -- Content for active window
            active = active,
            -- Content for inactive window(s)
            inactive = nil,
        },

        -- Whether to set Vim's settings for statusline (make it always shown)
        set_vim_settings = true,
    }
end)
