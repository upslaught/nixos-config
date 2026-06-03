{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
in {
  stylix.targets.mako.enable = false;

  services.mako = {
    enable = true;

    settings = {
      width = 360;
      height = 150;
      margin = "12";
      padding = "10,14";

      border-size = 1;
      border-radius = 0;

      font = "${font} 10";

      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      max-icon-size = 48;

      default-timeout = 5000;
      ignore-timeout = false;

      anchor = "top-right";
      layer = "overlay";

      group-by = "app-name";
      sort = "-time";

      background-color = "#${c.base01}ee";
      text-color = "#${c.base06}ff";
      border-color = "#${c.base02}ff";
      progress-color = "over #${c.base0D}44";
    };

    extraConfig = ''
      [urgency=low]
      border-color=#${c.base03}ff
      default-timeout=3000

      [urgency=high]
      border-color=#${c.base08}ff
      background-color=#${c.base01}ff
      default-timeout=0
    '';
  };
}
