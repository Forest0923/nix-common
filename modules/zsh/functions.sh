# Custom Functions
tmux-copy-remote() {
	ssh "$1" 'tmux show-buffer' | pbcopy
}

compdef _hosts tmux-copy-remote

unflag() {
	tmux set-environment -g -u __HM_SESS_VARS_SOURCED
	tmux set-environment -g -u __HM_ZSH_SESS_VARS_SOURCED
}
