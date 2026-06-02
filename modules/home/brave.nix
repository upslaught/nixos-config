{ pkgs, ... }:
{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };
}

