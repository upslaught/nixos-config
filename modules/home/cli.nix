{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [xdg-utils wl-clipboard];
  programs = {
    # i wouldn't consider this a cli but whatever
    foot = {
      enable = true;
      settings.main.font = "${config.stylix.fonts.sansSerif.name}:size=16";
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
