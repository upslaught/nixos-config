{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    enable = true;
    settings = {
      prefer-no-csd = true;

    };
  };
}
