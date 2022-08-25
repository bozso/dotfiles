-- 'Minischeme' color scheme
-- Derived from base16 (https://github.com/chriskempson/base16) and
-- mini_palette palette generator
local palette

-- Dark palette is an output of 'MiniBase16.mini_palette':
-- - Background '#112641' (LCh(uv) = 15-20-250)
-- - Foreground '#e2e98f' (Lch(uv) = 90-60-90)
-- - Accent chroma 75
if vim.o.background == "dark" then
    palette = {
        base00 = "#112641",
        base01 = "#3a475e",
        base02 = "#606b81",
        base03 = "#8691a7",
        base04 = "#d5dc81",
        base05 = "#e2e98f",
        base06 = "#eff69c",
        base07 = "#fcffaa",
        base08 = "#ffcfa0",
        base09 = "#cc7e46",
        base0A = "#46a436",
        base0B = "#9ff895",
        base0C = "#ca6ecf",
        base0D = "#42f7ff",
        base0E = "#ffc4ff",
        base0F = "#00a5c5",
    }
    -- use_cterm = {
    --     base00 = 235,
    --     base01 = 238,
    --     base02 = 60,
    --     base03 = 103,
    --     base04 = 186,
    --     base05 = 186,
    --     base06 = 229,
    --     base07 = 229,
    --     base08 = 223,
    --     base09 = 173,
    --     base0A = 71,
    --     base0B = 156,
    --     base0C = 170,
    --     base0D = 87,
    --     base0E = 225,
    --     base0F = 38,
    -- }
end

-- Light palette is an 'inverted dark', output of 'MiniBase16.mini_palette':
-- - Background '#e2e5ca' (LCh(uv) = 90-20-90)
-- - Foreground '#002a83' (Lch(uv) = 15-60-250)
-- - Accent chroma 75
if vim.o.background == "light" then
    local mod_palette = {
        -- background
        base00 = "#ffffff",
        base01 = "#bcbfa4",
        base02 = "#979a7e",
        base03 = "#73765a",
        base04 = "#324490",
        -- foreground
        base05 = "#000000",
        base06 = "#0000e4",
        base07 = "#080500",
        base08 = "#5e2200",
        base09 = "#a86400",
        base0A = "#008818",
        base0B = "#004500",
        base0C = "#b34aad",
        base0D = "#004b76",
        base0E = "#7d0077",
        base0F = "#0086ae",
    }

    palette = mod_palette
    -- use_cterm = {
    --     base00 = 254,
    --     base01 = 250,
    --     base02 = 246,
    --     base03 = 243,
    --     base04 = 60,
    --     base05 = 18,
    --     base06 = 4,
    --     base07 = 232,
    --     base08 = 52,
    --     base09 = 130,
    --     base0A = 28,
    --     base0B = 22,
    --     base0C = 133,
    --     base0D = 24,
    --     base0E = 90,
    --     base0F = 31,
    -- }
end

if palette then
    require("mini.base16").setup {
        palette = palette,
        -- use_cterm = use_cterm,
        use_cterm = true,
        plugins = { default = true },
    }
    vim.g.colors_name = "mycolors"
end
