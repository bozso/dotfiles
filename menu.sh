#! /usr/bin/env sh

py="python3.6"
music_player="audacious"
dotfiles="$HOME/packages/src/github.com/bozso/dotfiles"

set -e

opt="-fn -adobe-helvetica-bold-r-normal-*-25-180-100-100-p-138-iso8859-1"

alias mymenu="dmenu $opt -i"
alias dpass="dmenu $opt -nf \"black\" -nb \"black\" <&-"

temu="lxterminal"

debug() {
	notify-send -i "$icons/debug.png" "Debug" "$1" -t 2500
}

perr() {
	printf "%s\n" "$*" >&2
}

check_narg() {
	if [ "$1" -lt "$2" ]; then
		perr "error: Wrong number of arguments!"
		return 1
	fi
}

dprompt() {
	[ "$(printf 'No\nYes' | mymenu -p "$1")" = "Yes" ] && "$2"
}

notify() {
	return
	if [ -n "$3" ]; then
		notify-send -i "$icons/$3" "$1" "$2" -t 1500
	else
		notify-send "$1" "$2" -t 1500
	fi
}

extract_music() {
	for zipfile in /tmp/*.zip; do
		local outpath="/home/istvan/Zenék/$(basename "$zipfile" .zip)"
		# mkdir -p "$outpath"
		notify "Extracting file" "$zipfile"

		unzip "$zipfile" -d "$outpath"
	done
}

update_clean() {
	notify "Updating..."

	local o1="$(sudo apt-get update)"
	local o2="$(sudo apt-get upgrade)"
	local o3="$(sudo apt-get dist-update)"

	# notify "Update complete." "$o1\n$o2\n$3"

	local o1="$(sudo apt-get clean)"
	local o2="$(sudo apt-get autoremove)"

	notify "Cleaning..."
	notify "Cleaning  complete." "$o1\n$o2"
}

last_field() {
	awk -F '/' '{print $NF}'
}

playlists() {
	local path="/home/istvan/Zenék/playlists"

	local sel="$(ls -1 "$path"/* | last_field |
		mymenu -p "Select playlist:")"

	if [ -n "$sel" ]; then
		local path="$path/$sel"
		notify "Playing music" "$sel" "music_note.png"
		"$music_player" "$path" &
	fi
}

workspace() {
	check_narg $# "2"

	local name="$1"
	local path="$2"

	tmux start-server

	echo "$name $(tmux ls)"
	local bool="$(in_str "$name" "$(tmux ls)")"
	echo "$bool"

	if [ "$bool" = "false" ]; then
		notify "tmux" "Starting session $name"
		tmux new-session -d -t "$name"
		tmux send-keys "cd $path" C-m
		tmux split-window -h -c "$path"
		tmux select-pane -t 2
		tmux send-keys "mc" C-m
		tmux split-window -v -c "$path"
		tmux select-pane -t 1
	fi

	"$temu" -e "tmux attach-session -d -t \"$name\""

}

work() {
	local sel="$(dselect "$repos" "Select repo:")"
	local path="$(mget "$sel" "$repos")"

	workspace "$sel" "$path"
}

bitwarden() {
	local sel="$(rbw list | mymenu -p \"Select password:\")"
	rbw get "$sel" | xclip -i -selection clipboard
}

mc() {
	local sel="$(ls -d -1 "$HOME"/*/ |
		awk -F '/' '{print $(NF - 1)}' |
		mymenu -p "Select directory:")"

	if [ -n "$sel" ]; then
		local path="$HOME/$sel"
		notify "Started Midnight Commander." "$path" "mc.png"
		"$temu" -e "mc $path"
	fi
}

servers="\
robosztus : robosztus.ggki.hu
zafir     : zafir.ggki.hu
eejit     : eejit.geo.uu.nl
"

_ssh_select() {
	echo "$(printf '%s\n' "$servers" |
		mymenu -p "Select server" -l 3)"
}

_ssh_calc_address() {
	local addr="$(printf '%s' "$1" |
		cut -d ':' -f 2 |
		tr -d ' ')"

	echo "$(printf 'istvan@%s' "$addr")"
}

_ssh_mount() {
	local name="$(printf '%s' "$1" |
		cut -d ':' -f 1 |
		tr -d ' ')"

	local path="$HOME/mount/$name"
	local cmd="$(printf 'sshfs %s: %s' "$2" "$path")"
	"$cmd"
}

_ssh_join() {
	local cmd="$(printf 'ssh %s' "$1")"
	"$cmd"
}

manage_ssh() {
	local mode="$1"

	local server="$(_ssh_select)"
	local addr="$(_ssh_calc_address "$server")"

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

storage() {
	local mount_dir="/home/istvan/mount/storage"
	# local prog="${HOME}/packages/usr/bin/mount.cifs"
	local prog="mount.cifs"
	local url="//storage.ggki.hu/bozsoi/"
	mkdir -p "$mount_dir"
	echo "sudo $prog $url $mount_dir -o username=bozsoi,vers=2.1,rw"
	sudo "$prog" "$url" "$mount_dir" -o username=bozsoi,vers=2.1,rw
}

connect() {
	manage_ssh "join"
}

mount() {
	manage_ssh "mount"
}

mcon() {
	local server="$(_ssh_select)"
	local addr="$(_ssh_calc_address "$server")"

	_ssh_mount "$server" "$addr"
	_ssh_join "$addr"
}

poweroff() {
	notify-send "Did you push all git repositories?" \
		"Check git repositories!" -u "critical" -i "$icons/warning.png"
	dprompt "Shutdown?" "shutdown -h now"
}

gamma() {
	local path="/home/istvan/Dokumentumok/gamma_doc"

	local sel="$(ls -1 "$path"/*.html | last_field |
		mymenu -p "Select program:" -l 10)"

	if [ -n "$sel" ]; then
		local path="$path/$sel"
		notify "Opening documentation" "$sel" "music_note.png"
		"$BROWSER" "$path"
	fi
}

notebook() {
	"$miniconda"/bin/jupyter notebook
}

rotp() {
	java -jar plz-out/bin/prebuilt/rotp/Remnants.jar
}

dog() {
	houndd -conf="/home/istvan/packages/src/github.com/bozso/dotfiles/configs/repos.json"
}

modules="
bitwarden
notebook
poweroff
playlists
git
mc
connect
repos_all
extract_music
work
gamma
mount
dog
mcon
wincap
selcap
storage
rotp
"

select_module() {
	local sel="$(printf "%s\n" "$modules" | mymenu -p "Select from modules:")"

	for module in "$(printf "%s\n" "$modules")"; do
		case $sel in
		$module)
			"$module"
			;;
		*) ;;

		esac
	done
}

Basename() {
	while IFS= read -r line; do
		printf '%s\n' "$(basename "$line" .png)"
	done
}

import() {
	"$py" "$dotfiles"/bin/import.py "$@"
}

wincap() {
	import screen
}

selcap() {
	import select
}

programs() {
	PATH="$PATH:$HOME/packages/usr/bin"
	dmenu_run "$opt"
}

main() {
	check_narg $# 1

	case $1 in
	"programs")
		programs
		;;
	"modules")
		select_module
		;;
	"import")
		import select
		;;
	"screen")
		import screen
		;;
	*)
		printf "Unrecognized option %s!\n" "$1" >&2
		return 1
		;;
	esac
}

main "$@"
