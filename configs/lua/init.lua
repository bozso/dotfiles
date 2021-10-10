vim.wo.colorcolumn = "79"

local options = {
    wildignore = "*.o",
}

for key, opt in pairs(options) do
    vim.o[key] = opt
end

vim.g.mapleader = " "
