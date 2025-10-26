{
  programs.zellij = {
    enable = true;
    settings = {
      theme = "iceberg-dark";
      pane_frames = false;
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
      default_layout = "compact";
      show_startup_tips = false;
    };
  };
}
