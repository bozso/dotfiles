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
        user = "dm6718",
        repos = { "RITSAR" },
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
        desc = "alternative regex",
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
        user = "dblalock",
        repos = { "bolt" },
        desc = "decrease calculation time for matrix operations",
    },
    {
        user = "paudetseis",
        repos = { "PlateFlex" },
        desc = "Estimating effective elastic thickness of the lithosphere",
    },
    {
        user = "nvim-lua",
        repos = { "plenary.nvim" },
    },
    {
        user = "LukeSmithxyz",
        repos = { "etc", "based.cooking", "landchad" },
    },
    {
        user = "roman-kashitsyn",
        repos = { "phantom-newtype" },
        desc = "abstractions for phantom types e.g. ids, units",
    },
    {
        user = "LvAprograms",
        repos = { "IntroToNumericalGeodynamicModelling" },
    },
    {
        user = "IanBoyanZhang",
        repos = { "radar_sar_rma" },
    },
    {
        user = "ggciag",
        repos = { "mandyoc" },
    },
    {
        user = "ibraheemdev",
        repos = { "modern-unix" },
    },
    {
        user = "seismicreservoirmodeling",
        repos = { "SeReMpy" },
        desc = "Seismic Reservoir Modeling Python package",
    },
    {
        user = "starfishprime101",
        repos = { "Infrasound-Monitor" },
        desc = "Low cost infrasound monitor using i2c digital differential pressure sensor",
    },
    {
        user = "higham",
        repos = { "what-is" },
        desc = "Important concepts in numerical analysis and related areas",
    },
    {
        user = "ambujmishra0008",
        repos = { "Landslide-Forecasting-System" },
    },
    {
        user = "insarlab",
        repos = { "PySolid", "MintPy", "PyAPS", "MiaplPy" },
    },
}

local releases_only = {
    {
        user = "nim-lang",
        repos = { "Nim" },
    },
    {
        user = "makepath",
        repos = { "xarray-spatial" },
    },
    {
        user = "mvdan",
        repos = { "sh" },
    },
    {
        user = "zslayton",
        repos = { "lifeguard" },
    },
    {
        user = "jart",
        repos = { "cosmopolitan" },
    },
    {
        user = "ejmahler",
        repos = { "RustFFT" },
    },
    {
        user = "Theldus",
        repos = { "sourcery" },
        desc = [[Spell-checker written in C]],
    },
    {
        user = "tizonia",
        repos = { "tizonia-openmax-il" },
        desc = [[
            Command-line cloud music player for Linux with support for
            Spotify, Google Play Music, YouTube, SoundCloud, TuneIn,
            iHeartRadio, Plex servers and Chromecast devices.
        ]],
    },
    {
        user = "blue-yonder",
        repos = { "tsfresh" },
        desc = "Automatic extraction of relevant features from time series",
    },
    {
        user = "zpl-c",
        repos = { "tester", "zpl" },
    },
    {
        user = "pydata",
        repos = { "xarray" },
    },
    {
        user = "muesli",
        repos = { "duf" },
        desc = "disc usage analyzer",
    },
    {
        user = "hadolint",
        repos = { "hadolint" },
        desc = "docker linter",
    },
    {
        user = "doy",
        repos = { "rbw" },
    },
    {
        user = "schollz",
        repos = { "croc" },
        desc = "send files",
    },
    {
        user = "errata-ai",
        repos = { "vale" },
        desc = "code aware prose linter",
    },
    {
        user = "dlr-eoc",
        repos = { "ukis-pysat" },
        desc = "download multispectral images",
    },
    {
        user = "extrawurst",
        repos = { "gitui" },
    },
    {
        user = "fatiando",
        repos = { "pooch" },
    },
    {
        user = "nivekuil",
        repos = { "rip" },
    },
    {
        user = "bopen",
        repos = { "xarray-sentinel" },
    },
    {
        user = "yannforget",
        repos = { "asarapi" },
    },
    {
        user = "Zulko",
        repos = { "moviepy" },
    },
    {
        user = "samtay",
        repos = { "so" },
    },
    {
        user = "Nukesor",
        repos = { "pueue" },
    },
    {
        user = "wbthomason",
        repos = { "packer.nvim" },
    },
    {
        user = "SciTools",
        repos = { "iris" },
    },
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
