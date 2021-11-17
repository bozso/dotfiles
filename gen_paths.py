import os.path as path

home = path.expanduser("~")
config = path.join(home, ".config")

this = path.join(home, "packages", "src", "github.com", "bozso", "dotfiles")

plz = path.join(this, "plz-out")


def path_prebuilt(name):
    return path.join(plz, name, "prebuilt")

gen, binpath = path_prebuilt("gen"), path_prebuilt("bin")

def gen_paths():
    with open(path.join(gen, "paths"), "r") as f:
        content = f.read()

    paths = content.split(":")
    paths = ":".join(path.join(binpath, p) for p in paths)
    paths = "%s:%s" % (paths, binpath)

    with open(path.join(config, "paths_gen.sh"), "w") as f:
        f.write("export PATH=\"${PATH}:%s\"" % paths)


def main():
    gen_paths()


if __name__ == "__main__":
    main()
