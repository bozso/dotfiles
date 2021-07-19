
detach() {
    tmux detach > /dev/null
}

workspace() {
    local name="$1"

    # detach from a tmux session if in one
    detach

    [ -z $(tmux list-sessions -F "#{session_name}" | \
           grep -q "${name}") ] && return
}
