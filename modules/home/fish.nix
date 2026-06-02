{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    plugins = [
      { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
    ];
  };
}
