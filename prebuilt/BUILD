def github_release(owner, repo, version):
    return "https://github.com/%s/%s/releases/download/%s" % (
        owner,
        repo,
        version,
    )

def simple_remote(setup):
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
    return {
        "name": "golangci-lint",
        "exported_files": ["golangci-lint-%s-${OS}-${ARCH}/golangci-lint" % version],
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
        "url": "https://github.com/golangci/golangci-lint/releases/download/v%s/golangci-lint-%s-%s-%s.tar.gz" % (
            version,
            version,
            CONFIG.OS,
            CONFIG.ARCH,
        ),
    }

def stylua(version):
    return {
        "name": "stylua",
        "exported_files": ["stylua"],
        "url": "https://github.com/JohnnyMorganz/StyLua/releases/download/v%s/stylua-%s-%s.zip" % (
            version,
            version,
            CONFIG.OS,
        ),
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

def dprint(version):
    # https://github.com/dprint/dprint/releases/download/0.18.2/
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
            github_release(owner = "dprint", repo = "dprint", version = version),
            CONFIG.OS,
        ),
    }

package = 0

version = 1

packages = {
    "node": (node, "14.18.1"),
    "stylua": (stylua, "0.11.2"),
    "golangci": (golangci, "1.38.0"),
    "zig": (zig, "0.8.1"),
    "dprint": (dprint, "0.18.2"),
}

every = {
    key: val[package](val[version])
    for key, val in packages.items()
}

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
