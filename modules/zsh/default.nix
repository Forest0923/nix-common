{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    grml-zsh-config
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    profileExtra = ''
      # Homebrew
      if test /opt/homebrew/bin/brew &> /dev/null; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
      fi
    '';
    # https://mynixos.com/home-manager/option/programs.zsh.initContent
    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        ########################
        # --- lib.mkBefore --- #
        ########################
        ${builtins.readFile ./pre.sh}
        #zmodload zsh/zprof
      '')
      (lib.mkOrder 850 ''
        ###########################
        # --- GRML Zsh Config --- #
        ###########################

        # Load before fzf's zsh integration
        # https://github.com/nix-community/home-manager/blob/d305eece827a3fe317a2d70138f53feccaf890a1/modules/programs/fzf.nix
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      '')
      (lib.mkOrder 1000 ''
        ###################
        # --- Default --- #
        ###################
        ${builtins.readFile ./functions.sh}

        ${builtins.readFile ./prompt.sh}
      '')
      (lib.mkOrder 1500 ''
        #######################
        # --- lib.mkAfter --- #
        #######################
        #zprof
      '')
    ];
    shellAliases = {
      # ls
      ls = "command eza";
      la = "command eza -la";
      ll = "command eza -l";
      lh = "command eza -hAl";
      l = "command eza -l";
      tree = "command eza -T";

      ## Execute \kbd{ls -lSrah}
      dir = "command eza -lSrah";
      ## Only show dot-directories
      lad = "command eza -d .*(/)";
      ## Only show dot-files
      lsa = "command eza -a .*(.)";
      ## Only files with setgid/setuid/sticky flag
      lss = "command eza -l *(s,S,t)";
      ## Only show symlinks
      lsl = "command eza -l *(@)";
      ## Display only executables
      lsx = "command eza -l *(*)";
      ## Display world-{readable,writable,executable} files
      lsw = "command eza -ld *(R,W,X.^ND/)";
      ## Display the ten biggest files
      lsbig = "command eza -flh *(.OL[1,10])";
      ## Only show directories
      lsd = "command eza -d *(/)";
      ## Only show empty directories
      lse = "command eza -d *(/^F)";
      ## Display the ten newest files
      lsnew = "command eza -rtlh *(D.om[1,10])";
      ## Display the ten oldest files
      lsold = "command eza -rtlh *(D.Om[1,10])";
      ## Display the ten smallest files
      lssmall = "command eza -Srl *(.oL[1,10])";
      ## Display the ten newest directories and ten newest .directories
      lsnewdir = "command eza -rthdl *(/om[1,10]) .*(D/om[1,10])";
      ## Display the ten oldest directories and ten oldest .directories
      lsolddir = "command eza -rthdl *(/Om[1,10]) .*(D/Om[1,10])";

      # cat
      cat = "bat";
      cats = "bat --style=header --decorations=always";

      # ghq
      cdghq = "cd $(ghq root); cd $(ghq list | fzf --reverse --height 40%)";
      updghq = "cd $(ghq root); ghq get -u $(ghq list | fzf --reverse --height 40%)";

      up = "cd ..";
      refsh = "unset __HM_SESS_VARS_SOURCED; unset __HM_ZSH_SESS_VARS_SOURCED; exec zsh -l";
      neofetch = "curl -s https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch | bash";
      print256colours = "curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash";
    };
  };
}
