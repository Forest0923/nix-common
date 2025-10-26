{
  description = "Common HM/Nix modules";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }:
    let
      hmModules = {
        bash = ./modules/bash;
        bat = ./modules/bat;
        eza = ./modules/eza;
        fzf = ./modules/fzf;
        git = ./modules/git;
        neovim = ./modules/neovim;
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
