{
  description = "Common HM/Nix modules";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "git+ssh://git@github.com/Forest0923/herdr.git?ref=master-forest0923";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { herdr, ... }:
    let
      hmModules = {
        bash = ./modules/bash;
        bat = ./modules/bat;
        eza = ./modules/eza;
        fzf = ./modules/fzf;
        git = ./modules/git;
        herdr = import ./modules/herdr { inherit herdr; };
        kubie = ./modules/kubie;
        neovim = ./modules/neovim;
        opencode = ./modules/opencode;
        ripgrep = ./modules/ripgrep;
        starship = ./modules/starship;
        tmux = ./modules/tmux;
        vscode = ./modules/vscode;
        wezterm = ./modules/wezterm;
        zellij = ./modules/zellij;
        zsh = ./modules/zsh;
      };
      appModules = {
        ndev = ./applications/ndev;
      };

      pickHm = names: map (name: hmModules.${name}) names;
      pickApp = names: map (name: appModules.${name}) names;
    in
    {
      lib = {
        hmModules = hmModules;
        appModules = appModules;
        pickHm = pickHm;
        pickApp = pickApp;
      };
    };
}
