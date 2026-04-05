{
  description = "libbpf + CO-RE development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # BPF compilation
              clang
              llvm

              # libbpf and tools
              libbpf
              bpftools
              elfutils

              # Build tools
              gnumake
              pkg-config
              zlib
            ];

            env = {
              ARCH = builtins.replaceStrings
                [ "x86_64" "aarch64" ]
                [ "x86" "arm64" ]
                pkgs.stdenv.hostPlatform.linuxArch;
            };

            shellHook = ''
              echo "libbpf + CO-RE dev environment"
              echo "  clang:   $(clang --version | head -1)"
              echo "  bpftool: $(bpftool version 2>/dev/null || echo 'available')"
              echo ""
              echo "Generate vmlinux.h:"
              echo "  bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h"
            '';
          };
        }
      );
    };
}
