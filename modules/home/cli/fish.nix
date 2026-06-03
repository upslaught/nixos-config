{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    shellAliases = {
      nh = "env NIXOS_INSTALL_BOOTLOADER=1 nh";
    };

    plugins = [
      { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
    ];
  };
}
