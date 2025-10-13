{
  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./bashrc;
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
      refsh = "unset __HM_SESS_VARS_SOURCED; exec bash -l";
      neofetch = "curl -s https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch | bash";
      print256colours = "curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash";
    };
  };
}
