local cfg = {
    rss = require "rss.github",
    download = {
        eve_ost = {
            url = "https://www.modenstudios.com/EVE/music/",
            dir = "/home/istvan/Zenék/eve",
        },
    },
}

run("download", cfg)
