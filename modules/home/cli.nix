{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [antigravity-cli xdg-utils wl-clipboard];

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
