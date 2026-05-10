{
  description = "Security tools";
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
              busybox
              cyberchef
              dirb
              enum4linux-ng
              exploitdb
              gobuster
              inetutils
              john
              mariadb.client
              metasploit
              nmap
              redis
              responder
              samba
              tcpdump
              thc-hydra
              wordlists
            ];

            env = {
              ARCH =
                builtins.replaceStrings [ "x86_64" "aarch64" ] [ "x86" "arm64" ]
                  pkgs.stdenv.hostPlatform.linuxArch;
            };
          };
        }
      );
    };
}
