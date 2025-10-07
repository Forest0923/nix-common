{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fira
    fira-code
  ];
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
