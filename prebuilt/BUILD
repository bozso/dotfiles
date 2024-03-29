def github_release(owner, repo, version):
    return "https://github.com/%s/%s/releases/download/%s" % (
        owner,
        repo,
        version,
    )

def binary_remote(cfg):
    return remote_file(
        name = cfg["name"],
        out = cfg["out"],
        binary = True,
        hashes = cfg.get("hashes", None),
        url = cfg["url"],
    )

def simple_remote(setup):
    exp = setup.get("exported_files", None)
    return remote_file(
        name = setup["name"],
        out = setup.get("out"),
        binary = True,
        exported_files = exp,
        extract = setup.get("extract", True),
        hashes = setup.get("hashes"),
        strip_prefix = setup.get("strip_prefix"),
        url = setup["url"],
    )


def node(version):
    return {
        "name": "node",
        "exported_files": [],
        "url": "https://nodejs.org/dist/v%s/node-v%s-%s-x64.tar.xz" % (
            version,
            version,
            CONFIG.OS,
        ),
        "out": "node/v%s" % version,
        "strip_prefix": "node-v%s-%s-x64" % (version, CONFIG.OS),
        "bin": "node/v%s/bin" % version,
    }

def zig(version):
    return {
        "name": "zig",
        "exported_files": [],
        "url": "https://ziglang.org/download/%s/zig-%s-x86_64-%s.tar.xz" % (
            version,
            CONFIG.OS,
            version,
        ),
        "out": "zig/v%s" % version,
        "strip_prefix": "zig-%s-x86_64-%s" % (CONFIG.OS, version),
        "bin": "zig/v%s" % version,
    }

def nvim(cfg):
    pre = "nvim-%s64" % CONFIG.OS
    out = "neovim"
    version = cfg["version"]
    outdir = "%s/%s" % (out, version)

    
    release = github_release(
        owner = cfg["owner"],
        repo = cfg["repo"],
        version = "v" + version,
    )
    # https://github.com/antoineco/neovim-neovim/releases/download/v0.8.0/nvim-linux64.tar.gz

    return {
        "name": "neovim",
        "exported_files": [],
        "hashes": [
            # 0.5.1
            # nvim-linux64.tar.gz
            "sha256: d4b5b3984f607eaec1cca1df33120adfbaa89cf167d0cac77eb95fd1a9c21e9d",
            # nvim.appimage
            "sha256: 1cfbc587ea5598545ac045ee776965a005b1f0c26d5daf5479b859b092697439",
            # nvim.appimage.zsync
            "sha256: 65be33fc7bfe939019693d3a8781da97def1b848d083d023d172e8a79a3d1f0a",
            # nvim-macos.tar.gz
            "sha256: d736845b8b63e443970ea93636dfbde3e2673a70d2058c057e41b836ac4f6f6c",
            # nvim-win64.zip
            "sha256: 0e0dd552a1f28b222b10c07fb94787548cf443b0db6845cf683857e2e13724d2",
            # nvim-win32.zip
            "sha256: d098236b443f487ac82be522e50c4259ee2043370943404db3ab38e06d6d39fa",

            # 0.6.0
            # nvim-linux64.tar.gz
            "sha256: 9a7f72e25747c3839f2c8978ef4f902aada0c60ad4b5ff0cb8b9d4c1f0b35586",
            # nvim.appimage
            "sha256 8a2b8bb009f5a10f2908c6806c4745e064a6032db89de7895805fb979c90a08e",
            # nvim.appimage.zsync
            "sha256: a20073fc161e3c5ce204e301c39a434943ac9a9dc4438e8371191a014067ac55",
            # nvim-macos.tar.gz
            "sha256 03cdbfeec3493f50421a9ae4246abe4f9493715f5e151a79c4db79c5b5a43acc",
            # nvim-win64.zip
            "sha256: d46a161a8e025f8a03a75b1181372f2712116e4edf566b2569cdcc4f371f80c4",

            # 0.7.0
            # nvim-linux64.tar.gz
            "sha256: 5b3fced3f185ae1e1497cb5f949597c4065585fc26e7cd25a31f5f791dbd9b59",
            # nvim-linux64.deb
            "sha256: 4c36e1708b99f24327cde6fff2c19c2b4217e1a289fac90c2c10492df3ea7a71",
            # nvim.appimage
            "sha256: ac1caae4f1c54e0ce126b9313d993cb0d1cc4a81ef3e09dd26772be37aaa61db",
            # nvim.appimage.zsync
            "sha256: 9711fd721732ac189e8fa40aea6aadc5816861cf53f6ac498bd21cd6cf602f85", 
            # nvim-macos.tar.gz
            "sha256: 6260a2edb2da35af02b986c8a6506138afcb3f78f81a80734214b2cadf390a42",
            # nvim-win64.zip
            "sha256: a72a90e2897ea296b777c325a37c981a0b51e2fe0c8b8735e3366b65e958cddc",
            # nvim-win64.msi
            "sha256: c79b647338c3728e8d690ff70f81a4dda815adf9195cfdcfaa4f715514b0b3b2",

            # 0.8.0
            # nvim-linux64.tar.gz
            "sha256: 1af27471f76f1b4f7ad6563c863a4a78117f0515e3390ee4d911132970517fa7",
            "sha256: d3fc12bda179c0b48d9dd965f6e3878f5b34619bf217ae61c0288141486c3407",
            # nvim-linux64.deb
            "sha256: 215c88e8cf3fefcd02ef45dc8cdad563e1c601faeddca41565b6b852fceb26b5",
            "sha256: ae502d24e4ffa11a8f141fecaf7e8000b9c809dcbf62bef9dadb485f2c6e142e",
            # nvim.appimage
            "sha256: e1e6512bd5d9081d293ac7d1283166e09cbb32d15063853ade4b03719919e22f",
            "sha256: 4f440c61263483216aea01a24d472df4a419b97d62f8accb8c557d1c350125af",
            # nvim.appimage.zsync
            "sha256: c36b78021333db3c5d312b83ff1634997c1085473e2cedce3862786eddae481d", 
            "sha256: 6483d5acdad52ed5306f45235dd287c0172e025d36331ed0c67e5da52d645efe", 
            # nvim-macos.tar.gz
            "sha256: abe0b0c1ca46b7d05e689d4791055a6dbbf2394cb53a6a8d8274813e6762c1f1",
            # nvim-win64.zip
            "sha256: c52e0a93e8bd7e0192c3fe4552d8b0fb66fc8e08b6949e92340cccc4fa3a9bd0",
            # nvim-win64.msi
            "sha256: 1f38694a43c9fb33b045407edaab793e4a4f6da6751ec6f09f6fd96da4fba786",
        ],
        "out": outdir,
        "bin": "%s/bin" % outdir,
        "strip_prefix": pre,
        "url": "%s/%s.tar.gz" % (
            release,
            pre,
        ),
    }

def dprint(version):
    return {
        "name": "dprint",
        "exported_files": ["dprint"],
        "hashes": [
            # darwin_amd64
            "sha256: 34a84bc9f40b5325df5bd797b4bcee7da8485b995117bb46d0dce08b855f1e64",
            # linux_amd64
            "sha256: aa7ec5bec46142c8d851845ee50032c2f2928960669712cb3b45bfc0d000a3c8",
        ],
        "url": "%s/dprint-x86_64-unknown-%s-gnu.zip" % (
            github_release(
                owner = "dprint",
                repo = "dprint",
                version = version,
            ),
            CONFIG.OS,
        ),
    }

def efm(version):
    name = "efm-langserver_v%s_%s_%s" % (version, CONFIG.OS, CONFIG.ARCH)
    tar = "%s.tar.gz" % name

    return {
        "name": "efm-langserver",
        "exported_files": ["%s/efm-langserver" % name],
        "url": "%s/%s" % (
            github_release(
                owner = "mattn",
                repo = "efm-langserver",
                version = "v" + version,
            ),
            tar,
        ),
    }

def clang(cfg):
    version = cfg[0]
    ubuntu_version = cfg[1]

    prefix = "clang+llvm-%s-x86_64-linux-gnu-ubuntu-%s" % (
        version,
        ubuntu_version,
    )

    url = github_release(
        owner = "llvm",
        repo = "llvm-project",
        version = "llvmorg-%s" % version,
    )

    url = "%s/%s.tar.xz" % (
        url,
        prefix,
    )

    out = "clang/%s" % version

    return {
        "name": "clang",
        "exported_files": [],
        "url": url,
        "out": out,
        "strip_prefix": prefix,
        "bin": "%s/bin" % out,
    }

def starship(version):
    root = "starship-x86_64-unknown-linux-musl"

    return {
        "name": "starship",
        "exported_files": ["starship"],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "starship",
                repo = "starship",
                version = "v" + version,
            ),
            root,
        ),
    }

def delta(cfg):
    version = cfg["version"]
    libc = cfg["libc"]

    root = "delta-%s-x86_64-unknown-${OS}-%s" % (version, libc)

    return {
        "name": "delta",
        "exported_files": ["%s/delta" % root],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "dandavison",
                repo = "delta",
                version = version,
            ),
            root,
        ),
    }

def deno(cfg):
    version = cfg["version"]
    libc = cfg["libc"]

    root = "deno-x86_64-unknown-linux-%s" % libc

    return {
        "name": "deno",
        "exported_files": ["deno"],
        "url": "%s/%s.zip" % (
            github_release(
                owner = "denoland",
                repo = "deno",
                version = "v" + version,
            ),
            root,
        ),
    }

def nnn(cfg):
    version = cfg["version"]
    root = "nnn"
    mode = cfg.get("mode")
    if mode is not None:
        root = "%s-%s" % (root, mode)

    root = "%s-static" % root

    return {
        "name": "nnn",
        "exported_files": [root],
        "url": "%s/%s-%s.x86_64.tar.gz" % (
            github_release(
                owner = "jarun",
                repo = "nnn",
                version = "v" + version,
            ),
            root,
            version,
        ),
    }

def fzf(version):
    root = "fzf-%s-${OS}_${ARCH}" % version

    return {
        "name": "fzf",
        "exported_files": ["fzf"],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "junegunn",
                repo = "fzf",
                version = version,
            ),
            root,
        ),
    }

def pandoc(version):
    root = "pandoc-%s" % version

    return {
        "name": "pandoc",
        "exported_files": ["%s/bin/pandoc" % root],
        "url": "%s/%s-${OS}-${ARCH}.tar.gz" % (
            github_release(
                owner = "jgm",
                repo = "pandoc",
                version = version,
            ),
            root,
        ),
    }

def bat(cfg):
    version = cfg["version"]
    libc = cfg["libc"]

    root = "bat-v%s-x86_64-unknown-${OS}-%s" % (version, libc)

    return {
        "name": "bat",
        "exported_files": ["%s/bat" % root],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "sharkdp",
                repo = "bat",
                version = "v" + version,
            ),
            root,
        ),
    }

def exa(cfg):
    version = cfg["version"]
    libc = cfg.get("libc")

    root = "exa-${OS}-x86_64"
    if libc is not None:
        root = "%s-%s" % (root, libc)

    root = "%s-v%s" % (root, version)

    return {
        "name": "exa",
        "exported_files": ["bin/exa"],
        "url": "%s/%s.zip" % (
            github_release(
                owner = "ogham",
                repo = "exa",
                version = "v" + version,
            ),
            root,
        ),
    }

def rg(cfg):
    version = cfg["version"]
    libc = cfg["libc"]

    root = "ripgrep-%s-x86_64-unknown-${OS}-%s" % (version, libc)

    return {
        "name": "rg",
        "exported_files": ["%s/rg" % root],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "BurntSushi",
                repo = "ripgrep",
                version = version,
            ),
            root,
        ),
    }

def hyperfine(cfg):
    version = cfg["version"]
    libc = cfg["libc"]

    root = "hyperfine-v%s-x86_64-unknown-${OS}-%s" % (version, libc)

    return {
        "name": "hyperfine",
        "exported_files": ["%s/hyperfine" % root],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "sharkdp",
                repo = "hyperfine",
                version = "v" + version,
            ),
            root,
        ),
    }

def dust(cfg):
    version = cfg["version"]
    libc = cfg["libc"]

    root = "dust-v%s-x86_64-unknown-${OS}-%s" % (version, libc)

    return {
        "name": "dust",
        "exported_files": ["%s/dust" % root],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "bootandy",
                repo = "dust",
                version = "v" + version,
            ),
            root,
        ),
    }

def xplr(cfg):
    version = cfg["version"]
    libc = cfg.get("libc", None)

    root = "xplr-${OS}"
    if libc is not None:
        root = "%s-%s" % (root, libc)

    return {
        "name": "xplr",
        "exported_files": ["xplr"],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "sayanarijit",
                repo = "xplr",
                version = "v" + version,
            ),
            root,
        ),
    }

def jq(version):
    file = "jq-${OS}64"

    return {
        "name": "jq",
        "extract": False,
        "exported_files": [],
        "url": "%s/%s" % (
            github_release(
                owner = "stedolan",
                repo = "jq",
                version = "jq-%s" % version,
            ),
            file,
        ),
        "out": "jq",
    }

def nim(version):
    name = "nim-%s" % version
    
    return {
        "name": "nim",
        "exported_files": [],
        "url": "https://nim-lang.org/download/%s-${OS}_x64.tar.xz" % (
                name,
        ),
        "out": "nim/%s" % version,
        "strip_prefix": name,
        "bin": "nim/%s/bin" % version,
    }

def clib(version):
    prefix = "clib-${OS}"
    file = "%s-%s.zip" % (prefix, version)

    return {
        "name": "clib",
        "exported_files": ["%s/*" % prefix],
        "url": "%s/%s" % (
            github_release(
                owner = "clibs",
                repo = "clib",
                version = version,
            ),
            file,
        ),
    }

def inkscape(config):
    url_tpl = "https://inkscape.org/gallery/item/29256/Inkscape-%s-x86_64.AppImage"

    return {
        "name": "inkscape",
        "extract": False,
        "url": url_tpl % config.hash,
        "exported_files": [],
        "out": "inkscape",
    }

def zellij(version):
    prefix = "zellij-x86_64-unknown-${OS}-musl"

    return {
        "name": "zellij",
        "exported_files": ["zellij"],
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "zellij-org",
                repo = "zellij",
                version = "v%s" % version,
            ),
            prefix,
        ),
    }

def fonts(config):
    tpl = "'%s-Regular Nerd Font Complete.otf'"
    version = config["version"]
    name = config["name"]

    url = github_release(
        owner="ryanoasis",
        repo="nerd-fonts",
        version="v%s" % version
    )

    return {
        "name": name,
        "exported_files": [tpl % name],
        "url": "%s/%s.zip" % (
            url,
            name,
        ),
        "out": "fonts",
    }

def tectonic(config):
    version = config["version"]
    libc= config["libc"]

    name = "tectonic-%s-x86_64-unknown-${OS}-%s" % (version, libc)

    url = github_release(
        owner="tectonic-typesetting",
        repo="tectonic",
        version="tectonic%%40%s" % version
    )

    return {
        "name": "tectonic",
        "exported_files": ["tectonic"],
        "url": "%s/%s.tar.gz" % (
            url,
            name,
        ),
    }

def sccache(config):
    version = "v%s" % config["version"]
    libc = config["libc"]

    name = "sccache-dist-%s-x86_64-unknown-${OS}-%s" % (version, libc)

    url = github_release(
        owner="mozilla",
        repo="sccache",
        version=version,
    )

    return {
        "name": "sccache",
        "exported_files": ["%s/sccache-dist" % name],
        "url": "%s/%s.tar.gz" % (
            url,
            name,
        ),
    }

def julia(config):
    version = config["version"]
    libc = config["libc"]
    version_short = ".".join(version.split(".")[:-1])

    if libc == "glibc":
        libc = "linux"


    name_v = "julia-%s" % version
    name = "%s-%s-x86_64" % (name_v, libc)

    url = "https://julialang-s3.julialang.org/bin/%s/x64/%s" % (
        libc, version_short
    )

    out = "julia/%s" % version

    return {
        "name": "julia",
        "exported_files": [],
        "url": "%s/%s.tar.gz" % (
            url,
            name,
        ),
        "strip_prefix": name_v,
        "out": out,
        "bin": "%s/bin" % out,
    }

def go(config):
    version = config

    url = "https://go.dev/dl/go%s.${OS}-amd64.tar.gz" % version
    out = "go/%s" % version

    return {
        "name": "go",
        "exported_files": [],
        "url": url,
        "strip_prefix": "go",
        "out": out,
        "bin": "%s/bin" % out,
    }


def cifs_utils(config):
    version = config["version"]
    cflags = config["cflags"]
    url = "https://www.samba.org/ftp/linux-cifs/cifs-utils/cifs-utils-%s.tar.bz2" % version
    return None

def procs(config):
    version = "v%s" % config

    name = "procs-%s-x86_64-lnx" % version

    url = github_release(
        owner="dalance",
        repo="procs",
        version=version
    )

    return {
        "name": "procs",
        "exported_files": ["procs"],
        "url": "%s/%s.zip" % (
            url,
            name,
        ),
    }

def unciv(config):
    pass

def teal(config):
    version = config
    name = "tl-%s-${OS}-x86_64" % version
    url = github_release(
        owner="teal-language",
        repo="tl",
        version="v%s" % version
    )
    out = "teal/%s" % version

    return {
        "name": "teal",
        "exported_files": [],
        "strip_prefix": name,
        "out": out,
        "bin": out,
        "url": "%s/%s.tar.gz" % (
            url,
            name,
        ),
    }

def shellcheck(config):
    version = "v%s" % config
    name = "shellcheck-%s" % version

    url = github_release(
        owner="koalaman",
        repo="shellcheck",
        version=version
    )

    return {
        "name": "shellcheck",
        "exported_files": ["%s/shellcheck" % name],
        "url": "%s/%s.${OS}.x86_64.tar.xz" % (
            url,
            name,
        ),
    }

def shellharden(config):
    version = config
    name = "shellharden-%s-x86_64-${OS}-gnu" % version

    url = github_release(
        owner="anordal",
        repo="shellharden",
        version="v%s" % version
    )

    return {
        "kind": "binary",
        "name": "shellharden",
        "out": "shellharden",
        "url": "%s/%s" % (
            url,
            name,
        ),
    }

def shfmt(config):
    version = "v%s" % config
    name = "shfmt_%s_${OS}_amd64" % version

    url = github_release(
        owner="mvdan",
        repo="sh",
        version=version
    )

    return {
        "kind": "binary",
        "name": "shfmt",
        "out": "shfmt",
        "url": "%s/%s" % (
            url,
            name,
        ),
    }

def dmd(config):
    tpl = "http://downloads.dlang.org/releases/%s/dmd.%s.linux.tar.xz"
    url = tpl % (config.year, config.version)

    out = "dmd"

    return {
        "name": "dmd",
        "exported_files": [],
        "url": url,
        "out": out,
        "bin": "%s/dmd2/linux/bin64" % out,
    }

def dcd(config):
    version = "v%s" % config
    name = "dcd-%s-${OS}-x86_64" % version

    url = github_release(
        owner="dlang-community",
        repo="DCD",
        version=version
    )

    out = "dcd"

    return {
        "name": "dcd",
        "exported_files": ["dcd-server", "dcd-client"],
        "url": "%s/%s.tar.gz" % (
            url,
            name,
        ),
    }


def haxe(config):
    version = config
    name = "haxe-%s-linux64.tar.gz" % (version)

    url = github_release(
        owner="HaxeFoundation",
        repo="haxe",
        version=version
    )

    return {
        "name": "haxe",
        "exported_files": [],
        "url": "%s/%s" % (url, name),
        "strip_prefix": "haxe_20220306074705_e5eec31",
        "bin": "haxe",
        "out": "haxe",
    }

def pueue_cfg(cfg):
    version = "v%s" % cfg
    url = github_release(
        owner="Nukesor",
        repo="pueue",
        version=version
    )

    names = ["pueue", "pueued"]
    out = {}
    for name in names:
        exe_name = "%s-${OS}-x86_64" % name
        out[name] = {
            "extract": False,
            "name": name,
            "url": "%s/%s" % (
                url,
                exe_name,
            ),
            "out": name,
        }

    return out
    
def xplr(cfg):
    name = "xplr"
    version = cfg
    version = "v%s" % version

    url = github_release(
        owner="sayanarijit",
        repo="xplr",
        version=version
    )

    return {
        "name": name,
        "exported_files": ["xplr"],
        "url": "%s/xplr-${OS}.tar.gz" % (
            url
        ),
        # "out": "xplr",
    }

def nushell(cfg):
    version = cfg

    url = github_release(
        owner="nushell",
        repo="nushell",
        version=version
    )

    main_name = "nushell"
    name = "nu-%s-x86_64-unknown-${OS}-gnu" % version
    sub_name = "nushell-%s" % version

    return {
        "name": main_name,
        "exported_files": [],
        "url": "%s/%s.tar.gz" % (url, name),
        "strip_prefix": "%s/%s" % (name, sub_name),
        "out": main_name,
        "bin": "%s/nu" % main_name,
    }

def gitui(cfg):
    ver = cfg["version"]
    libc = cfg["libc"]
    version = "v%s" % ver

    url = github_release(
        owner="extrawurst",
        repo="gitui",
        version=version
    )

    name = "gitui-${OS}-%s" % libc

    return {
        "name": "gitui",
        "exported_files": ["gitui"],
        "url": "%s/%s.tar.gz" % (
            url, name
        ),
    }

def bun(cfg):
    # https://github.com/Jarred-Sumner/bun/releases/download/bun-v0.1.1/bun-linux-x64.zip
    ver = cfg
    version = "bun-v%s" % ver

    url = github_release(
        owner="oven-sh",
        repo="bun",
        version=version
    )

    name = "bun-${OS}-x64"

    return {
        "name": "bun",
        "exported_files": ["%s/bun" % name],
        "url": "%s/%s.zip" % (
            url, name
        ),
    }

def ripcord(cfg):
    version = cfg
    url = "https://cancel.fm/dl/Ripcord-%s-x86_64.AppImage" % version

    return {
        "name": "ripcord",
        "exported_files": [],
        "url": url,
        "out": "ripcord",
    }

def mage(cfg):
    version = cfg
    url = github_release(
        owner="magefile",
        repo="mage",
        version="v%s" % version,
    )

    filename = "mage_%s_Linux-64bit" % version
    url = "%s/%s.tar.gz" % (url, filename)

    return {
        "name": "mage",
        "exported_files": ["mage"],
        "url": url,
    }

def knit(cfg):
    # https://github.com/zyedidia/knit/releases/download/v0.1.1/knit-0.1.1-linux-amd64.tar.gz
    version = cfg

    url = github_release(
        owner="zyedidia",
        repo="knit",
        version="v%s" % version,
    )

    filename = "knit-%s-${OS}-amd64" % version
    url = "%s/%s.tar.gz" % (url, filename)

    return {
        "name": "knit",
        "exported_files": ["%s/knit" % filename],
        "url": url,
    }


def bcd(cfg):
    # https://framagit.org/Ezwen/bandcamp-collection-downloader/-/jobs/1515933/artifacts/raw/build/libs/bandcamp-collection-downloader.jar?inline=false
    url = "https://framagit.org/Ezwen/bandcamp-collection-downloader/-/jobs/%s/artifacts/raw/build/libs/bandcamp-collection-downloader.jar?inline=false"

    url = url % cfg

    return {
        "name": "bandcamp-collection-downloader",
        "exported_files": [],
        "url": url,
    }

def fish(version):
    # https://github.com/xxh/fish-portable/releases/download/3.4.1/fish-portable-musl-alpine-Linux-x86_64.tar.gz
    url = github_release(
        owner="xxh",
        repo="fish-portable",
        version=version,
    )

    filename = "knit-%s-${OS}-amd64" % version
    filename = "fish-portable-musl-alpine-Linux-x86_64.tar.gz"
    url = "%s/%s" % (url, filename)

    return {
        "name": "fish",
        "exported_files": ["bin/fish", "bin/fish_indent", "bin/fish.sh"],
        "url": url,
    }

fns = {
    "bun": bun,
    "fish": fish,
    "xplr": xplr,
    "dcd": dcd,
    "dmd": dmd,
    "teal": teal,
    "julia": julia,
    "gitui": gitui,
    "go": go,
    "shfmt": shfmt,
    "shellharden": shellharden,
    # "cifs_utils": cifs_utils,
    "clib": clib,
    "fonts": fonts,
    "zellij": zellij,
    "inkscape": inkscape,
    "nim": nim,
    "node": node,
    "rg": rg,
    "exa": exa,
    "zig": zig,
    "hyperfine": hyperfine,
    "bat": bat,
    "dprint": dprint,
    "nvim": nvim,
    "procs": procs,
    "efm": efm,
    "clang": clang,
    "tectonic": tectonic,
    "starship": starship,
    "delta": delta,
    # "ripcord": ripcord,
    "deno": deno,
    "dust": dust,
    "nnn": nnn,
    "fzf": fzf,
    "nushell": nushell,
    "knit": knit,
    "jq": jq,
    "xplr": xplr,
    "pandoc": pandoc,
    "sccache": sccache,
    "shellcheck": shellcheck,
    "haxe": haxe,
    # "unciv": unciv,
    "mage": mage,
    "bandcamp-collection-downloader": bcd,
}

multi_fns = {
    "pueue": pueue_cfg,
}

def gen_env(fns, versions):
    out = {}
    for key, val in fns.items():
        version = versions.get(key)
        if version is not None:
            out[key] = val(version)

    return out


home = {
    "fish": "3.4.1",
    "bun": "0.1.6",
    "clib": "2.7.0",
    "dcd": "0.13.6",
    "xplr": "0.18.0",
    "dmd": {
        "version": "2.099.0",
        "year": "2022",
    },
    "teal": "0.13.2",
    "shellharden": "4.1.1",
    "shfmt": "3.4.3",
    "fonts": {
        "version": "2.1.0",
        "name": "AurulentSansMono",
    },
    "cifs_utils": {
        "version": "6.9",
        "cflags": "",
    },
    # "unciv": "3.19.10",
    "zellij": "0.32.0",
    "inkscape": {"hash": "3bf5ae0"},
    "procs": "0.12.1",
    "node": "14.18.1",
    "nim": "1.6.0",
    "zig": "0.9.0",
    "nvim": {
        "version": "0.7.0",
        "owner": "neovim",
        "repo": "neovim",
    },
    #"nvim": {
     #   "version": "0.8.0",
      #  "owner": "antoineco",
       # "repo": "neovim-neovim",
    #},
    "dprint": "0.18.2",
    "starship": "1.2.1",
    "fzf": "0.28.0",
    "pandoc": "2.16.2",
    "jq": "1.6",
    "go": "1.19.2",
    "knit": "0.1.1",
    "misspell": "0.3.4",
    "haxe": "4.2.5",
    "nushell": "0.67.0",
    "gitui": {
        "version": "0.20.1",
        "libc": "musl",
    },
    "delta": {
        "version": "0.10.2",
        "libc": "musl",
    },
    "tectonic": {
        "version": "0.9.0",
        "libc": "musl",
    },
    "deno": {
        "version": "1.22.0",
        "libc": "gnu",
    },
    "bat": {
        "version": "0.18.3",
        "libc": "musl",
    },
    "hyperfine": {
        "version": "1.12.0",
        "libc": "musl",
    },
    "exa": {
        "version": "0.10.1",
        "libc": "musl",
    },
    "dust": {
        "version": "0.7.5",
        "libc": "musl",
    },
    "rg": {
        "version": "13.0.0",
        "libc": "musl",
    },
    "nnn": {
        "version": "4.4",
        "mode": "musl",
    },
    "sccache": {
        "version": "0.2.15",
        "libc": "musl",
    },
    "julia": {
        "version": "1.7.1",
        "libc": "glibc"
    },
    "pueue": "2.0.2",
    "ripcord": "0.4.29",
    "mage": "1.13.0",
    # "bandcamp-collection-downloader": "1515933",
}

def add(config):
    kind = config.get("kind", None)
    if (kind is not None) and (kind == "binary"):
        return binary_remote(config)

    return simple_remote(config)


every = gen_env(fns, home)

rules = []

for name, pkg in every.items():
    rules += [add(pkg)]


for name, pkg in multi_fns.items():
    cfg = home[name]
    subpkgs = pkg(cfg)
    for s in subpkgs.values():
        rules += [add(s)]


paths = ""

for pkg in every.values():
    binpath = pkg.get("bin")

    if binpath is not None:
        paths = "%s:%s" % (paths, binpath)

text_file(
    name = "paths",
    content = paths.lstrip(":"),
    deps=rules,
)
