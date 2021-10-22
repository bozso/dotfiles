
down="${pkgs}/downloaded"

dm_packer() {
    git clone --depth 1 \
        https://github.com/wbthomason/packer.nvim \
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

dm_symlinks() {
    ln -s "${dotfiles}/configs/lua" ~/.config/nvim/lua
}

flutter_version="2.5.3"
flutter_tarfile="flutter_linux_${flutter_version}-stable.tar.xz"
flutter_to="${down}/flutter/${flutter_version}"
flutter_here="$(pwd)"
flutter_path="${flutter_to}/bin"

dm_flutter() {
    set -euo pipefail
    local here="$(pwd)"

    cd /tmp
    wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${flutter_tarfile}"
    tar -xvf "${flutter_tarfile}"
    mkdir -p "${flutter_to}"
    mv flutter/{.,}* "${flutter_to}"
    cd "${here}"
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

PATH="${PATH}:${flutter_path}"
