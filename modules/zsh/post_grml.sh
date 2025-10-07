# --- post_grml.sh ---

if [[ $options[zle] = on ]]; then
	source <(${pkgs.fzf}/bin/fzf --zsh)
fi

if isDarwin && command -v /opt/homebrew/bin/brew &>/dev/null; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi
