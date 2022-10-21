down="$pkgs/downloaded"

copy_file() {
	cp "$1" "$2"
}

copy_dir() {
	cp -r "$1" "$2"
}

download() {
	[ ! -f "$2" ] && wget "$1"
}

dm_packer() {
	git clone --depth 1 \
		https://github.com/wbthomason/packer.nvim \
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

cache="/tmp/download_cache"
mkdir -p "$cache"

premake_version="5.0.0-alpha16"
premake_bin="$down/premake/$premake_version"

dm_premake() {
	set -euo pipefail

	local curr="$PWD"
	local tarfile="premake-$premake_version-linux.tar.gz"
	local url="https://github.com/premake/premake-core/releases/download/v$premake_version/$tarfile"
	local tarfile_down="$cache/$tarfile"
	mkdir -p "$premake_bin"

	cd "$cache"
	download "$url" "$tarfile_down"
	tar -xzvf "$tarfile_down" -C "$premake_bin"

	cd "$curr"
}

link_dir() {
	local from="$1"
	local to="$2"
	[ ! -d "$to" ] && ln -sf "$from" "$to"
}

link_file() {
	local from="$1"
	local to="$2"
	[ ! -f "$2" ] && ln -s "$from" "$to"
}

dm_symlinks() {
	link_dir "$dotfiles/configs/lua" "$HOME/.config/nvim/lua"
	link_dir "$dotfiles/configs/colors" "$HOME/.config/nvim/colors"
	link_dir "$dotfiles/configs/snippets" "$HOME/.config/nvim/snippets"
	link_dir "$dotfiles/plz-out/bin/prebuilt/fonts" "$HOME/.local/share/fonts"

	local conf="$HOME/.config"
	local zellij="$conf/zellij"
	mkdir -p "$zellij"
	link_file "$dotfiles/configs/zellij.yaml" "$zellij/config.yaml"
	link_file "$dotfiles/configs/redshift.conf" "$conf/redshift.conf"
	mkdir -p "$conf/meli"
	link_file "$dotfiles/configs/meli.toml" "$conf/meli/config.toml"
}

dm_firefox() {
	local fdir="/home/istvan/.mozilla/firefox/5okjrwhs.default-release"
	local cdir="$dotfiles/configs/firefox"

	copy_file "$cdir/user.js" "$fdir/user.js"
	# rm -rf "$fdir/chrome"
	copy_dir "$cdir/chrome" "$fdir"
}

please_version="16.14.0"
please_bin="$down/please/$please_version"

dm_plz() {
	local curr="$PWD"
	local tarfile="please_${please_version}_linux_amd64.tar.xz"
	local url="https://github.com/thought-machine/please/releases/download/v$please_version"
	local tarfile_down="$cache/$tarfile"

	mkdir -p "$please_bin" &&
		cd "$cache" &&
		download "$url/$tarfile" "$tarfile_down"
	tar -xvf "$tarfile_down" -C "$please_bin" \
		--strip-components=1 &&
		cd "$curr"
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
	"plz")
		dm_plz
		;;
	*)
		printf "unrecognized option %s" "$1"
		return 1
		;;
	esac
}

export PATH="$PATH:$premake_bin:$please_bin"
