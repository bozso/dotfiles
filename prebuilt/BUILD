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
    log.debug(setup)
    log.debug(setup["name"])
    return remote_file(
        name = setup["name"],
        out = setup.get("out"),
        binary = True,
        exported_files = setup["exported_files"],
        extract = True,
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

fns = {
    "node": node,
    "stylua": stylua,
    "golangci": golangci,
    "zig": zig,
    "dprint": dprint,
    "nvim": nvim,
    "efm": efm,
    "clang": clang,
    "starship": starship,
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
    "stylua": "0.11.2",
    "golangci": "1.38.0",
    "zig": "0.8.1",
    "dprint": "0.18.2",
    "nvim": "0.5.1",
    "efm": "0.0.38",
    "starship": "1.0.0",
    "clang": ("13.0.0", "16.04"),
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
