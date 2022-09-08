local M = {}

local modes = {
    "all",
    "commits",
    "releases",
}

local mode_arrays = {
    all = { "releases", "commits" },
    commits = { "commits" },
    releases = { "releases" },
}

local with_all = {
    {
        user = "KAWAIYOO",
        repos = { "LAMBDA" },
    },
    {
        user = "matthew-gaddes",
        repos = { "ICASAR" },
    },
    {
        user = "gbaier",
        repos = { "sarsim" },
    },
    {
        user = "hdkarimi",
        repos = { "awesome-gnss" },
    },
    {
        user = "Fernerkundung",
        repos = { "awesome-sentinel" },
    },
    {
        user = "dbohdan",
        repos = { "compilers-targeting-c" },
    },
    {
        user = "andrei-markeev",
        repos = { "ts2c" },
    },
    {
        user = "mayfrost",
        repos = { "guides" },
    },
    {
        user = "sebbekarlsson",
        repos = { "fuex" },
    },
    {
        user = "dalyagergely",
        repos = { "schupy" },
    },
    {
        user = "RadarCODE",
        repos = { "awesome-sar" },
    },
    {
        user = "dbekaert",
        repos = { "TRAIN", "StaMPS" },
    },
    {
        user = "dbekaert",
        repos = { "TRAIN" },
    },
    {
        user = "dblalock",
        repos = { "bolt" },
    },
    {
        user = "paudetseis",
        repos = { "PlateFlex" },
    },
    {
        user = "nvim-lua",
        repos = { "plenary.nvim" },
    },
    {
        user = "LukeSmithxyz",
        repos = { "etc", "based.cooking", "landchad" },
    },
}

local releases_only = {
    {
        user = "oven-sh",
        repos = { "bun" },
    },
    {
        user = "reneklacan",
        repos = { "symspell" },
    },
    {
        user = "neovim",
        repos = { "nvim-lspconfig", "neovim" },
    },
}

local github_repos = {}

local repos_with_modes = {
    all = with_all,
    releases = releases_only,
}

for _, mode in pairs(modes) do
    local curr_repos = repos_with_modes[mode]
    if curr_repos then
        for _, repo in pairs(curr_repos) do
            local curr_mode = mode_arrays[mode]
            local curr = {
                user = repo.user,
                repos = repo.repos,
                modes = curr_mode,
            }
            table.insert(github_repos, curr)
        end
    end
end

M.github_repos = github_repos

return M
