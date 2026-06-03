{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [xdg-utils wl-clipboard antigravity-cli];
  home.sessionVariables.NIXOS_OZONE_WL = "1"; # not sure where to put this

  programs = {
    foot = {
      enable = true;
      settings.main.font = lib.mkForce "${config.stylix.fonts.monospace.name}:size=16";
    };

    bat.enable = true;
    eza.enable = true;
    btop.enable = true;
    fd.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
