workspaces="
gotoolbox:$github/gotoolbox
arman:$srht/arman
shutil:$srht/shutil
"

workspace() {
    local selector="fzf"
    local selected=$(echo "${workspaces}" | "${selector}")

    local name=$(echo "${selected}" |  cut -d ":" -f 1)
    local path=$(echo "${selected}" |  cut -d ":" -f 2)

    # detach from a tmux session if in one
    tmws_detach

    [ -n $(tmux list-sessions -F "#{session_name}" | \
           grep -q "${name}") ] && tmws_attach "${name}" && return

    tmws_create_session "${name}" "${path}"
    tmws_setup_session
    tmws_attach "${name}"
}

tmws_attach() {
    local name="$1"
    tmux attach -t "${name}"
}

tmws_detach() {
    tmux detach > /dev/null
}

tmws_create_session() {
    local name="$1" path="$2"
    cd "${path}"
    tmux new-session -d -s "${name}"
}

tmws_setup_session() {
    local path="$1" editor="nvim"
    tmux rename-window "vim"

    tmux send-keys "${editor}" C-m
    tmux split-window -h -p 35

    tmux new-window -n fsys

    tmux send-keys "fm" C-m
    tmux split-window -h

    tmux select-window -t 1
}
