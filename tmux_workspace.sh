workspaces="
gotoolbox:$github/gotoolbox
arman:$srht/arman
shutil:$srht/shutil
"

workspace() {
	local path="$1"

	# detach from a tmux session if in one
	tmws_start_server
	tmws_detach

	echo "$path"

	if [ -z "$path" ]; then
		path=$(tmws_select_ws)
	fi

	local name
	name="$(basename "$path")"

	echo "$name" "$path"

	tmux has-session -t "$name" && tmws_attach "$name" && return

	tmws_create_session "$name" "$path"
	tmws_setup_session
	tmws_attach "$name"
}

tmws_start_server() {
	tmux start-server
}

tmws_select_ws() {
	local selector="fzf"
	local paths="$github:$bitbucket:$srht"
	local buf=""

	IFS=":"

	for line in $paths; do
		buf="$(printf "%s\n%s" "$buf" "$(ls -1 -d "$line"/*)")"
	done

	echo "$(echo "$buf" | "$selector")"
}

tmws_attach() {
	local name="$1"
	tmux attach -t "$name"
}

tmws_detach() {
	tmux detach >/dev/null
}

tmws_create_session() {
	local name="$1" path="$2"
	cd "$path" || return
	tmux new-session -d -s "$name"
}

tmws_setup_session() {
	local path="$1" editor="nvim"
	tmux rename-window "vim"

	# tmux send-keys "$editor" C-m
	tmux split-window -h -p 35

	tmux new-window -n fsys

	tmux send-keys "fm" C-m
	tmux split-window -h

	tmux select-window -t 1
}
