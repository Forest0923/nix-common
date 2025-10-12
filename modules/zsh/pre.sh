# .zshrc.pre
if [[ -z $TMUX ]] && [[ -z $ZELLIJ ]]; then
	if [[ $TERM_PROGRAM == vscode ]] || \
	   [[ $TERM_PROGRAM == WarpTerminal ]] || \
	   [[ $TERMINAL_EMULATOR == JetBrains-JediTerm ]] || \
	   [[ $ZED_TERM ]]; then
		# do nothing
	else
		tmux attach 2> /dev/null || {cd ~; tmux new} 2> /dev/null
	fi
fi
