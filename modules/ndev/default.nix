{
  lib,
  pkgs,
  config,
  ...
}:
let
  ndev = pkgs.writeShellApplication {
    name = "ndev";
    runtimeInputs = with pkgs; [
      fzf
      jq
    ];
    text = builtins.readFile ./ndev.sh;
  };
in
{
  options.programs.ndev = {
    enable = lib.mkEnableOption "ndev wrapper to select flake/devShell via fzf";
    configFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.xdg.configHome}/nix/flake-repos";
      description = "Path of repositories list used by ndev.";
    };
  };

  config = {
    programs.ndev.enable = lib.mkDefault true;
    home.packages = [ ndev ];
  };
}
