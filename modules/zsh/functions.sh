# Custom Functions
tmux-copy-remote() {
	if command -v pbcopy &> /dev/null; then
		ssh "$1" 'tmux show-buffer' | pbcopy
	elif command -v xclip &> /dev/null; then
		ssh "$1" 'tmux show-buffer' | xclip -selection clipboard
	elif command -v wl-copy &> /dev/null; then
		ssh "$1" 'tmux show-buffer' | wl-copy
	else
		echo "No clipboard utility found. Please install xclip or wl-clipboard."
		return 1
	fi
}

compdef _hosts tmux-copy-remote

unflag() {
	tmux set-environment -g -u __HM_SESS_VARS_SOURCED
	tmux set-environment -g -u __HM_ZSH_SESS_VARS_SOURCED
}
