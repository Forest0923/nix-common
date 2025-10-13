{
  description = "Common HM/Nix modules";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      hmModules = rec {
        bash = ./modules/bash;
        bat = ./modules/bat;
        eza = ./modules/eza;
        fzf = ./modules/fzf;
        git = ./modules/git;
        neovim = ./modules/neovim;
        tmux = ./modules/tmux;
        vscode = ./modules/vscode;
        wezterm = ./modules/wezterm;
        zsh = ./modules/zsh;
      };
      pick = names: map (name: hmModules.${name}) names;
    in
    {
      lib = {
        hmModules = hmModules;
        pickHm = pick;
      };
    };
}
