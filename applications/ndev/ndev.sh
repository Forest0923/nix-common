set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nix/flake-repos"
HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/ndev/history"
mkdir -p "$(dirname "$CFG")"; touch "$CFG"
mkdir -p "$(dirname "$HISTORY")"; touch "$HISTORY"

usage() {
	cat <<'EOF'
ndev                       # select flake and devShell via fzf, then run nix develop
ndev add [PATH|.]          # register a flake (must contain flake.nix)
ndev rm                    # unregister a flake via fzf
ndev list                  # list registered flakes
ndev clean                 # remove missing paths from the list
ndev update [-a|--all]     # update flake.lock (all or select via fzf)

Options:
  -c, --command CMD        # run CMD instead of $SHELL after entering devShell
EOF
}

add_repo() {
	local p="${1:-.}"
	p="$(cd "$p" && pwd)"
	if [[ ! -f "$p/flake.nix" ]]; then
		echo "error: flake.nix not found in $p" >&2
		exit 1
	fi
	grep -qxF "$p" "$CFG" || echo "$p" >> "$CFG"
	echo "added: $p"
}

rm_repo() {
	if ! grep -q . "$CFG"; then
		echo "no registered flakes." >&2
		exit 1
	fi
	local repo
	repo="$(cat "$CFG" | fzf --prompt='remove> ')"
	[[ -n "${repo:-}" ]] || exit 1
	grep -vxF "$repo" "$CFG" > "${CFG}.tmp"
	mv "${CFG}.tmp" "$CFG"
	echo "removed: $repo"
}

list_repo() {
	if ! grep -q . "$CFG"; then
		echo "no registered flakes." >&2
		exit 1
	fi
	cat "$CFG"
}

clean_repo() {
	awk '{
		cmd="test -f \""$0"/flake.nix\""
		if (system(cmd)==0) print $0
		}' "$CFG" > "${CFG}.tmp"
	mv "${CFG}.tmp" "$CFG"
	echo "cleaned"
}

update_flakes() {
	local all=false
	if [[ "${1:-}" == "-a" || "${1:-}" == "--all" ]]; then
		all=true
	fi

	if ! grep -q . "$CFG"; then
		echo "no registered flakes." >&2
		exit 1
	fi

	if $all; then
		while IFS= read -r repo; do
			if [[ -f "$repo/flake.nix" ]]; then
				echo "updating: $repo"
				(cd "$repo" && nix flake update)
			fi
		done < "$CFG"
	else
		local repo
		repo="$(cat "$CFG" | fzf --prompt='update> ' --preview='nix flake show {} 2>/dev/null | sed -n "1,80p"')"
		[[ -n "${repo:-}" ]] || exit 1
		echo "updating: $repo"
		(cd "$repo" && nix flake update)
	fi
}

save_history() {
	local repo="$1" dev="$2"
	echo "${repo}#${dev}" > "$HISTORY"
}

get_history() {
	[[ -f "$HISTORY" ]] && cat "$HISTORY" || echo ""
}

select_and_run() {
	if [[ -n "${IN_NIX_SHELL:-}" ]]; then
		echo "warning: already inside a nix shell, nesting." >&2
	fi

	# Use login shell from passwd (nix develop overrides $SHELL to non-interactive bash)
	local cmd
	if command -v getent >/dev/null 2>&1; then
		cmd="$(getent passwd "${USER}" | cut -d: -f7)"
	elif command -v dscl >/dev/null 2>&1; then
		cmd="$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')"
	else
		cmd="${SHELL}"
	fi
	cmd="${cmd:-${SHELL}}"

	# Parse options
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-c|--command)
				cmd="$2"
				shift 2
				;;
			*)
				echo "unknown option: $1" >&2
				exit 1
				;;
		esac
	done

	if ! grep -q . "$CFG"; then
		echo "no registered flakes. run 'ndev add .' first." >&2
		exit 1
	fi

	local last_choice
	last_choice="$(get_history)"
	local last_repo="${last_choice%#*}"

	# Sort repos with last used first
	local sorted_repos
	if [[ -n "$last_repo" ]] && grep -qxF "$last_repo" "$CFG"; then
		sorted_repos="$(echo "$last_repo"; { grep -vxF "$last_repo" "$CFG" || true; })"
	else
		sorted_repos="$(cat "$CFG")"
	fi

	local repo
	repo="$(echo "$sorted_repos" | fzf --prompt='repo> ' --preview='nix flake show {} 2>/dev/null | sed -n "1,80p"')"
	[[ -n "${repo:-}" ]] || exit 1

	local sys
	sys="$(nix eval --raw --impure --expr \
		'if builtins ? currentSystem
then builtins.currentSystem
else (import <nixpkgs> {}).stdenv.hostPlatform.system')"
	local devs
	devs="$(nix flake show --json "$repo" \
		| jq -r --arg s "$sys" '.devShells[$s] | keys[]?' )"

	[[ -n "$devs" ]] || { echo "no devShells found in this flake"; exit 1; }

	# Sort devShells with last used first
	local last_dev="${last_choice#*#}"
	local sorted_devs
	if [[ "$last_repo" == "$repo" ]] && echo "$devs" | grep -qxF "$last_dev"; then
		sorted_devs="$(echo "$last_dev"; { echo "$devs" | grep -vxF "$last_dev" || true; })"
	else
		sorted_devs="$devs"
	fi

	local dev
	dev="$(printf '%s\n' "$sorted_devs" | fzf --prompt='devShell> ' --select-1)"
	[[ -n "${dev:-}" ]] || exit 1

	save_history "$repo" "$dev"

	nix develop "${repo}#${dev}" -c "$cmd"
}

case "${1:-}" in
	add)    add_repo "${2:-.}" ;;
	rm)     rm_repo ;;
	list)   list_repo ;;
	clean)  clean_repo ;;
	update) shift; update_flakes "$@" ;;
	-h|--help) usage ;;
	-c|--command) select_and_run "$@" ;;
	"")     select_and_run ;;
	*)      echo "unknown subcommand: $1" >&2; usage; exit 1 ;;
esac
