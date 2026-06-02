{ pkgs, ... }:
{
  home.packages = [ pkgs.wl-clipboard ];

  programs = {
    # i wouldn't consider this a cli but whatever
    foot.enable = true;

    bat.enable = true;
    eza.enable = true;
    btop.enable = true;
    fd.enable = true;
    zoxide = {
      enable = true;
      enableFishIntegration = true;

      options = [
        "--cmd cd" # +50 iq
      ];
    };
  };
}
