set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nix/flake-repos"
mkdir -p "$(dirname "$CFG")"; touch "$CFG"

usage() {
	cat <<'EOF'
ndev                  # select flake and devShell via fzf, then run nix develop
ndev add [PATH|.]     # register a flake (must contain flake.nix)
ndev clean            # remove missing paths from the list
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

clean_repo() {
	awk '{
		cmd="test -f \""$0"/flake.nix\""
		if (system(cmd)==0) print $0
		}' "$CFG" > "${CFG}.tmp"
	mv "${CFG}.tmp" "$CFG"
	echo "cleaned"
}

select_and_run() {
	if ! grep -q . "$CFG"; then
		echo "no registered flakes. run 'ndev add .' first." >&2
		exit 1
	fi

	local repo
	repo="$(fzf --prompt='repo> ' --preview='nix flake show {} 2>/dev/null | sed -n "1,80p"' < "${CFG}")"
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

	local dev
	dev="$(printf '%s\n' "$devs" | fzf --prompt='devShell> ')"
	[[ -n "${dev:-}" ]] || exit 1

	echo "running: nix develop '${repo}#${dev}'"
	nix develop "${repo}#${dev}" -c "${SHELL}"
}

case "${1:-}" in
	add)   add_repo "${2:-.}" ;;
	clean) clean_repo ;;
	-h|--help) usage ;;
	"")    select_and_run ;;
	*)     echo "unknown subcommand: $1" >&2; usage; exit 1 ;;
esac
