def github_release(owner, repo, version):
    return "https://github.com/%s/%s/releases/download/%s" % (
        owner,
        repo,
        version,
    )

def binary_remote(name, exported_files, url, out = None, strip_prefix = None, hashes = None):
    return remote_file(
        name = name,
        out = out,
        binary = True,
        exported_files = exported_files,
        extract = True,
        hashes = hashes,
        strip_prefix = strip_prefix,
        url = url,
    )

def simple_remote(setup):
    return remote_file(
        name = setup["name"],
        out = setup.get("out"),
        binary = True,
        exported_files = setup["exported_files"],
        extract = setup.get("extract", True),
        hashes = setup.get("hashes"),
        strip_prefix = setup.get("strip_prefix"),
        url = setup["url"],
    )

def golangci(version):
    root = "golangci-lint-%s-${OS}-${ARCH}" % version

    url = "%s/%s.tar.gz" % (
        github_release(
            owner = "golangci",
            repo = "golangci-lint",
            version = "v" + version,
        ),
        root,
    )

    return {
        "name": "golangci-lint",
        "exported_files": ["%s/golangci-lint" % root],
        "hashes": [
            # darwin_arm64
            "sha256: 9748c2697a65d2962106e74db6db6e3acc9066ec5ff0b81f47d803479e7b4994",
            # darwin_amd64
            "sha256: a9b5eb572ce55ae900a3935640fa5e199729e784a6f058e8077a9a2126e00857",
            # linux_amd64
            "sha256: 97be8342ac9870bee003904bd8de25c0f3169c6b6238a013d6d6862efa5af992",
            # freebsd_amd64
            "sha256: a05d18756522b2803ab53d49f5da074c298b69546691338809dbd16c7a4840fd",
        ],
        "url": url,
    }

def stylua(version):
    url = "%s/stylua-%s-%s.zip" % (
        github_release(
            owner = "JohnnyMorganz",
            repo = "StyLua",
            version = "v" + version,
        ),
        version,
        CONFIG.OS,
    )

    return {
        "name": "stylua",
        "exported_files": ["stylua"],
        "url": url,
    }

def node(version):
    return {
        "name": "node",
        # "exported_files": ["bin/", "include/", ""],
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

def nvim(version):
    pre = "nvim-%s64" % CONFIG.OS
    out = "neovim/%s" % version

    return {
        "name": "neovim",
        "exported_files": [],
        "hashes": [
            # darwin_amd64
            "sha256: d736845b8b63e443970ea93636dfbde3e2673a70d2058c057e41b836ac4f6f6c",
            # linux_amd64
            "sha256: d4b5b3984f607eaec1cca1df33120adfbaa89cf167d0cac77eb95fd1a9c21e9d",
        ],
        "out": out,
        "bin": "%s/bin" % out,
        "strip_prefix": pre,
        "url": "%s/%s.tar.gz" % (
            github_release(
                owner = "neovim",
                repo = "neovim",
                version = "v" + version,
            ),
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
    # https://github.com/jgm/pandoc/releases/download/2.16.2/pandoc-2.16.2-linux-amd64.tar.gz
    root = "pandoc-%s" % version
    # root = "pandoc-%s-${OS}-${ARCH}" % version

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

def zls(version):
    prefix = "x86_64-${OS}"
    file = "%s.tar.xz" % prefix

    return {
        "name": "zls",
        "exported_files": ["%s/zls" % prefix],
        "url": "%s/%s" % (
            github_release(
                owner = "zigtools",
                repo = "zls",
                version = version,
            ),
            file,
        ),
    }


fns = {
    "nim": nim,
    "zls": zls,
    "node": node,
    "rg": rg,
    "exa": exa,
    "stylua": stylua,
    "golangci": golangci,
    "zig": zig,
    "hyperfine": hyperfine,
    "bat": bat,
    "dprint": dprint,
    "nvim": nvim,
    "efm": efm,
    "clang": clang,
    "starship": starship,
    "delta": delta,
    "deno": deno,
    "dust": dust,
    "nnn": nnn,
    "fzf": fzf,
    "jq": jq,
    "xplr": xplr,
    "pandoc": pandoc,
}

def gen_env(fns, versions):
    out = {}
    for key, val in fns.items():
        version = versions.get(key)
        if version is not None:
            out[key] = val(version)

    return out

home = {
    "node": "14.18.1",
    "nim": "1.6.0",
    "stylua": "0.11.2",
    "golangci": "1.38.0",
    "zig": "0.8.1",
    "zls": "0.1.0",
    "dprint": "0.18.2",
    "nvim": "0.5.1",
    "efm": "0.0.38",
    "starship": "1.0.0",
    "fzf": "0.28.0",
    "pandoc": "2.16.2",
    "clang": ("13.0.0", "16.04"),
    "jq": "1.6",
    "delta": {
        "version": "0.10.2",
        "libc": "musl",
    },
    "deno": {
        "version": "1.16.3",
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
    "xplr": {
        "version": "0.16.4",
        "libc": "musl",
    },
    "nnn": {
        "version": "4.4",
        "mode": "musl",
    },
}

every = gen_env(fns, home)

for name, pkg in every.items():
    simple_remote(pkg)

paths = ""

for pkg in every.values():
    binpath = pkg.get("bin")

    if binpath is not None:
        paths = "%s:%s" % (paths, binpath)

text_file(
    name = "paths",
    content = paths.lstrip(":"),
)
