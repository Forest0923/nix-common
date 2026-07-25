{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--reverse"
    ];
    historyWidget.options = [
      "--reverse"
    ];
  };
}
