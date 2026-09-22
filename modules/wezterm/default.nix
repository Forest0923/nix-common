{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    fira
    fira-code
  ];
  programs.wezterm = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.wezterm;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
