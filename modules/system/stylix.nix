{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/chalk.yaml";
    autoEnable = true;

    targets = {
      kmscon.enable = false; # doesn't work on 26.11
    };

    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/01/wallhaven-01kl31.jpg";
      hash = "sha256-m5LSpyn67y7TOI0p54IYk7DYO9Nb0ahiN3sTgrAsU6Q=";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    fonts = {
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };

      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
    };
  };
}
