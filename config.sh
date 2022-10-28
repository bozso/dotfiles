#!/usr/bin/env bash
export temu=lxterminal
export BROWSER="chromium-browser"

pkgs="$HOME/packages"
src="$pkgs/src"
pkgs_bin="$pkgs/usr/bin"
export PATH="$PATH:$HOME/bin:$HOME/.local/share/nvim/mason/bin"

export github="$src/github.com/bozso"
export bitbucket="$src/bitbucket.org/ibozso"
export srht="$src/sr.ht"

export dotfiles="$github/dotfiles"
mount="$HOME/mount"

vinstall() {
	nvim -u "$dotfiles/configs/install.vim"
}

startup() {
	redshift &
	ripcord &
	thunderbird &
}

storage() {
	sudo mount.cifs //storage/bozsoi "$HOME"/mount/storage/ -o user=bozsoi,vers=3
}

storage_nas1() {
	sudo mount.cifs //nas1.ggki.hu/nkp "$HOME"/mount/nas1 -o user=bozsoi,vers=3
}

ftp_ai() {
	local target="$mount/gifi"
	mkdir -p "$target"
	curlftpfs gifi@storage.ggki.hu "$target"
}

install_deps() {
	local deps=" cifs-utils curlftpfs "

	sudo apt-get install "$deps"
}

ossl="openssl"

get_page() {
	local url="$1"
	echo "$(echo -n | "$ossl" s_client -showcerts -connect "$url")"
}

get_cert() {
	local url="$1"

	"$(get_page "$url")" 2>/dev/null |
		sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
}

bw_impl() {
	local target="$1"

	local sel
	sel="$(rbw list | fzf)"
	[ -z "$sel" ] && return
	rbw get "$sel" | xclip -i -selection "$target"
}

bwp() {
	bw_impl "primary"
}

tmws() {
	workspace "$@"
}

alias bw="bwp"
alias rg="rigrep"

fvim() {
	local filename
	filename="$(find . -type d \( -name .git -o -name plz-out \) -prune -o -type f -print | fzf)"
	nvim "$filename"
}

bw_c() {
	bw_impl "clipboard"
}

gen_repos() {
	gotoolbox genrepos \
		-config "configs/repository_settings.json" \
		-out "configs/local_repos.json"
}

report() {
	gotoolbox repositories \
		-command status \
		-html -out "/tmp/git_report.html" \
		-config "$github/dotfiles/configs/local_repos.json"
}

local_install() {
	if [ "$#" != "1" ]; then
		printf "error: local_install: One argument (package name) is required!\n" >&2
		return 1
	fi

	rm *.deb

	apt download "$1"
	mkdir -p "$pkgs"

	dpkg -x *.deb "$pkgs"

	rm *.deb
}

tar_com() {
	tar -czvf "$1".tar.gz "$1"
}

tar_ext() {
	tar -xzvf "$1".tar.gz "$1"
}

gm() {
	sh "$dotfiles"/git.sh "$@"
}

proton() {
	check_narg $# 1

	local p_sapps="/home/istvan/.steam/steam/steamapps"
	local p_compat="$p_sapps/compatdata/eofs"
	local e_proton="$p_sapps/common/Proton 3.16/proton"

	# STEAM_COMPAT_DATA_PATH="/home/istvan/.proton/" python "$e_proton" run $1 LD_PRELOAD=$p_freetype
	# PROTON_USE_WINED3D11=1 \
	# PROTON_NO_ESYNC=1 \
	STEAM_COMPAT_DATA_PATH=$p_compat \
		DXVK_LOG_LEVEL=debug \
		python "$e_proton" run "$1"

}

alias nano="nano -u"
alias nbrc="nano -u ~/.bashrc"
alias fm="nnn-musl-static -d -R"
alias tb="gotoolbox"
alias light="sudo \$pkgs_bin/xbacklight -set"
alias ze="zellij"
alias zr="zellij run"

alias reload='. ${dotfiles}/config.sh'
alias menu='sh ${dotfiles}/menu.sh modules'
alias import='sh ${dotfiles}/menu.sh import'

nvim_packer() {
	# Only load packer configuration to avoid errors
	# trying to start neovim when packages defined in
	# plugins.lua are not yet installed and the Packer{Compile,Install}
	# commands cannot be defined.
	nvim -S "$dotfiles/configs/lua/plugins.lua"
}

paths="
$github/insar_meteo
$github/pygomma
$github/utils
$bitbucket/stmpy
$bitbucket/stm-bi
"

same_as() {
	xrandr --output VGA-1 --same-as LVDS-1
}

same_as_hdmi() {
	xrandr --output HDMI-1 --same-as eDP-1
}

monitor_institute() {
	xrandr --output HDMI-1 --same-as eDP-1 --right-of eDP-1
}

for path in "$paths"; do
	p="$path/init.sh"

	if [ -f "$p" ]; then
		sh "$p" "$path"
	fi
done

# Disable ascii coloring as geany's compiler message panel can not
# handle them at the moment
export NO_COLOR=1

export GOPATH="$pkgs"
export PATH="$PATH:$pkgs/usr/bin:$pkgs/bin:$HOME/.nimble/bin"
export PATH="$PATH:$dotfiles/bin:/opt/cisco/anyconnect/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$pkgs/usr/lib"

export OMP_NUM_THREADS=8

evaluate() {
	# printf "%s" "$*"
	eval "$*"
}

mount_storage() {
	local storage=/home/istvan/mount/storage
	mkdir -p "$storage"

	sudo mount //storage/bozsoi "$storage" \
		-o user=bozsoi,dir_mode=0777,file_mode=0666
}

compress_pdf() {
	local in="$1"
	local out="$2"

	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET \
		-dBATCH -dPrinted=false \
		-sOutputFile="$out" "$in"
}

simple_ps() {
	PS1="\u@\H\n"
}

eval_if_dir() {
	if [ -d "$1" ]; then
		evaluate "$2"
	fi
}

get_miniconda() {
	local url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
	local curr_dir="$PWD"
	cd "/tmp" && wget "$url"
	cd "$curr_dir"
}

servers="\
robosztus : robosztus.ggki.hu
zafir     : zafir.ggki.hu
eejit     : eejit.geo.uu.nl
"

eval_if_file() {
	if [ -f "$1" ]; then
		evaluate "$2"
	fi
}

_ssh_select() {
	echo "$(printf '%s\n' "$servers" | fzf)"
}

_ssh_calc_address() {
	local addr
	addr="$(printf '%s' "$1" |
		cut -d ':' -f 2 |
		tr -d ' ')"

	echo "$(printf 'istvan@%s' "$addr")"
}

_ssh_mount() {
	local name path cmd
	name="$(printf '%s' "$1" |
		cut -d ':' -f 1 |
		tr -d ' ')"

	path="$HOME/mount/$name"
	cmd="$(printf 'sshfs %s: %s' "$2" "$path")"
	"$cmd"
}

_ssh_join() {
	local cmd
	cmd="$(printf 'ssh %s' "$1")"
	"$cmd"
}

_manage_ssh() {
	local mode="$1"

	local server
	local addr
	server="$(_ssh_select)"
	addr="$(_ssh_calc_address "$server")"

	case "$mode" in
	"mount")
		_ssh_mount "$server" "$addr"
		;;
	"join")
		_ssh_join "$addr"
		;;
	*)
		printf 'Unknown option: %s!\n' "{mode}"
		;;
	esac
}

ssh_mount() {
	_manage_ssh "mount"
}

ssh_join() {
	_manage_ssh "join"
}

# source a file if it exists
source_if() {
	if [ -f "$1" ]; then
		. "$1"
	fi
}

source_if "$HOME/.config/paths_gen.sh"

evaluate "$(starship init bash)"

eval_if_file "starship" "$(starship init bash)"
eval_if_dir "$HOME/bake/bake" "$HOME/bake/bake env"

source_if "$HOME/.nix-profile/etc/profile.d/nix.sh"
source_if "$HOME/.cargo/env"
source_if "$HOME/.xmake/profile"

down="$pkgs/downloaded"
clang="$down/clang/lib"

if [ -d "$clang" ]; then
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$clang"
fi

source_if "$dotfiles/tmux_workspace.sh"

conda="$HOME/miniconda3"
export conda_lib="$conda/lib"

. "$dotfiles/manage.sh"
source_if "/home/istvan/.sdkman/bin/sdkman-init.sh"

mm_setup() {
	eval "$(micromamba shell hook -s bash)"
}

export DOWNLOAD_THREADS=32

bandcamp_download() {
	java -jar -jar "$HOME/bin/bandcamp-collection-downloader.jar" \
		-d "$HOME/Zenék" \
		--cookies-file=/tmp/bandcamp.com_cookies.txt bozsoi \
		-j "$DOWNLOAD_THREADS"
}

alias mm="micromamba"
