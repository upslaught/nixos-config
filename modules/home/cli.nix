{pkgs, ...}: {
  programs = {
    # i wouldn't consider this a cli but whatever
    foot.enable = true;

    bat.enable = true;
    eza.enable = true;
    btop.enable = true;
    fd.enable = true;
    xdg-utils.enable = true;
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
