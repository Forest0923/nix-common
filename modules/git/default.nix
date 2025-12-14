{ config, lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = lib.mkDefault "";
        email = lib.mkDefault "";
      };
      alias = {
        d = "diff";
        dc = "diff --cached";
        graph = "log --graph --all --decorate";
        wt = "worktree";
      };
      init = {
        defaultbranch = "main";
      };
      ghq = {
        root = "${config.home.homeDirectory}/src";
      };
    };
  };
}
