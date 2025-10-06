{ config, nixosConfig, ... }:
{
  programs.git = {
    enable = true;
    userName = "Masahiro Mori";
    userEmail = "masahirom0923@gmail.com";
    aliases = {
      graph = "log --graph --all --decorate";
      wt = "worktree";
    };
    extraConfig = {
      init = {
        defaultbranch = "main";
      };
      ghq = {
        root = "${config.home.homeDirectory}/src";
      };
    };
  };
}
