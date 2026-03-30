{
  description = "Rust + aya eBPF development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.self.overlays.default
              ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: {
        rustToolchain =
          let
            fenixPkgs = inputs.fenix.packages.${prev.stdenv.hostPlatform.system};
          in
          fenixPkgs.combine [
            fenixPkgs.latest.clippy
            fenixPkgs.latest.rustc
            fenixPkgs.latest.cargo
            fenixPkgs.latest.rustfmt
            fenixPkgs.latest.rust-src
          ];
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              rustToolchain
              rust-analyzer

              # BPF tools
              bpftools
              elfutils

              # Build dependencies
              pkg-config
              zlib
              llvm
            ];

            env = {
              RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
            };

            shellHook = ''
              echo "Rust + aya eBPF dev environment"
              echo "  rustc:   $(rustc --version)"
              echo "  cargo:   $(cargo --version)"
              echo "  bpftool: $(bpftool version 2>/dev/null || echo 'available')"
              echo ""
              echo "Create a new aya project:"
              echo "  cargo install cargo-generate"
              echo "  cargo generate https://github.com/aya-rs/aya-template"
            '';
          };
        }
      );
    };
}
