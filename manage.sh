down="${pkgs}/downloaded"

dm_packer() {
    git clone --depth 1 \
        https://github.com/wbthomason/packer.nvim \
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

cache="/tmp/download_cache"
mkdir -p "${cache}"

premake_version="5.0.0-alpha16"
premake_bin="${down}/premake/${premake_version}"

download() {
    [ ! -f "$2" ] && wget "$1"
}

dm_premake() {
    set -euo pipefail

    local curr="$(pwd)"
    local tarfile="premake-${premake_version}-linux.tar.gz"
    local url="https://github.com/premake/premake-core/releases/download/v${premake_version}/${tarfile}"
    local tarfile_down="${cache}/${tarfile}"
    mkdir -p "${premake_bin}"

    cd "${cache}"
    download "${url}" "${tarfile_down}"
    tar -xzvf "${tarfile_down}" -C "${premake_bin}"

    cd "${curr}"
}

dm_symlinks() {
    ln -s "${dotfiles}/configs/lua" ~/.config/nvim/lua
}

dm() {
    if [ "$#" != "1" ]; then
        printf "error: dm: one argument, subcommand, is required!\n" >&2
        return 1
    fi

    case "$1" in
        "packer")
            dm_packer
            ;;
        "premake")
            dm_premake
            ;;
        "symlinks")
            dm_symlinks
            ;;
        "flutter")
            flutter_path="$(dm_flutter)"
            ;;
        *)
            printf "unrecognized option %s" "$1"
            return 1
    esac
}

export PATH="${PATH}:${premake_bin}"
