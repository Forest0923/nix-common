{ hermes-agent }:
{ pkgs, config, ... }:
{
  imports = [ hermes-agent.homeManagerModules.default ];
  programs.hermes-agent = {
    enable = true; # the hermes CLI on your PATH
    desktop.enable = false; # the Electron application and a launcher
  };
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    settings.model.default = "qwen/qwen3.8-27b";
    environmentFiles = [ config.sops.secrets."hermes/env".path ];
  };
  sops.secrets."hermes/env" = {
    key = "hermes/env";
  };
}
