{ herdr }:
{ pkgs, ... }:
{
  home.packages = [
    herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
