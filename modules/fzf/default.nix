{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--reverse"
    ];
    historyWidgetOptions = [
      "--reverse"
    ];
  };
}
