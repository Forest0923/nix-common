{ herdr }:
{ pkgs, ... }:
{
  home.packages = [
    herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [keys]
    focus_pane_down = ["prefix+j", "prefix+down"]
    focus_pane_left = ["prefix+h", "prefix+left"]
    focus_pane_right = ["prefix+l", "prefix+right"]
    focus_pane_up = ["prefix+k", "prefix+up"]
    navigate_workspace_down = ["down", "j"]
    navigate_workspace_up = ["up", "k"]
    settings = "prefix+shift+s"
    split_horizontal = "prefix+\""
    split_vertical = "prefix+%"
    workspace_picker = ["prefix+w", "prefix+s"]

    [ui]
    prompt_new_tab_name = false
    sidebar_collapsed_mode = "hidden"
    tab_bar_position = "top"
  '';
}
