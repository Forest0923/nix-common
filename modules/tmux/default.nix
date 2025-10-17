{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 0;
    keyMode = "vi";

    plugins = with pkgs; [
      # Load theme first to prevent overwriting variables by other plugins
      tmuxPlugins.tokyo-night-tmux # https://github.com/janoamaral/tokyo-night-tmux

      # Session management
      tmuxPlugins.resurrect # https://github.com/tmux-plugins/tmux-resurrect
      tmuxPlugins.continuum # https://github.com/tmux-plugins/tmux-continuum

      # Misc.
      tmuxPlugins.sensible # https://github.com/tmux-plugins/tmux-sensible
    ];

    extraConfig = ''
      # Reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

      # Sort session list
      bind s choose-session -Z -O name

      # Clear history
      bind l clear-history \; display "Cleared"

      # Open panes and windows on current directory
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Configure plugins
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
      set -g @tokyo-night-tmux_window_id_style none

      set -g default-shell "$SHELL"
      set -g default-command "$SHELL"

      set -g allow-passthrough on

      # Restore sessions
      run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh"
    '';
  };
}
