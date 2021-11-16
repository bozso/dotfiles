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

def golangci():
    version = "1.38.0"
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

def stylua():
    version = "0.11.2"
    return {
        "name": "stylua",
        "exported_files": ["stylua"],
        "url": "https://github.com/JohnnyMorganz/StyLua/releases/download/v%s/stylua-%s-%s.zip" % (
            version,
            version,
            CONFIG.OS,
        ),
    }

def stylua():
    version = "0.11.2"
    return {
        "name": "stylua",
        "exported_files": ["stylua"],
        "url": "https://github.com/JohnnyMorganz/StyLua/releases/download/v%s/stylua-%s-%s.zip" % (
            version,
            version,
            CONFIG.OS,
        ),
    }

def node():
    version = "14.18.1"
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
    }

every = {
    "node": node(),
    "stylua": stylua(),
    "golangci": golangci(),
}

for name, pkg in every.items():
    simple_remote(pkg)

path = "${PATH}"

for pkg in every.values():
    out = pkg.get("out")

    if out is not None:
        path = "%s:%s/bin" % (path, out)

text_file(
    name = "paths.sh",
    content = "export PATH=\"%s\"" % path,
)
