{ config, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = lib.mkDefault "Your Name";
    userEmail = lib.mkDefault "user@example.com";
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
