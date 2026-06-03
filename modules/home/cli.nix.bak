{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [xdg-utils wl-clipboard];
  programs = {
    # i wouldn't consider this a cli but whatever
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

      # doesn't seem to work
      # enableFishIntegration = true;

      options = [
        "--cmd cd" # +50 iq
      ];
    };
  };
}
