{
  lib,
  pkgs,
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
  };

  config = {
    programs.ndev.enable = lib.mkDefault true;
    home.packages = [ ndev ];
  };
}
