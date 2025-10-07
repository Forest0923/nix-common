# --- post_grml.sh ---

if isdarwin && command -v /opt/homebrew/bin/brew &>/dev/null; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi
