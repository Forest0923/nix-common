{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs =
    { self, ... }@inputs:

    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        inputs.nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forAllSystems (
        { pkgs }:
        let
          python = pkgs.python314;
          venvDir = ".venv";
          requiredPipPackages = [
          ];
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              python
            ];
            shellHook = ''
              set -eo pipefail

              echo "Setting up Python virtual environment in '${venvDir}'..."
              REQUIRED_PACKAGES=(${builtins.toString requiredPipPackages})
              VENV_DIR="${venvDir}"
              REQ_HASH_FILE="$VENV_DIR/.req-hash"

              echo "Preparing environment..."
              if [ ! -d "$VENV_DIR" ]; then
                python -m venv "$VENV_DIR"
              fi
              . "$VENV_DIR/bin/activate" || true

              NEW_HASH="$(printf '%s\n' "''${REQUIRED_PACKAGES[@]}" | shasum -a 256 | awk '{print $1}')"
              OLD_HASH="$( [ -f "$REQ_HASH_FILE" ] && cat "$REQ_HASH_FILE" || echo )"

              if [ "$NEW_HASH" != "$OLD_HASH" ]; then
                echo "Installing/updating required packages..."
                python -m pip install --upgrade pip
                if [ ! ''${#REQUIRED_PACKAGES[@]} -eq 0 ]; then
                  python -m pip install "''${REQUIRED_PACKAGES[@]}"
                fi
                echo "$NEW_HASH" > "$REQ_HASH_FILE"
              fi
            '';
          };
        }
      );
    };
}
