{
  config,
  pkgs,
  ...
}: {
  stylix.targets.fuzzel.enable = false;

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${config.stylix.fonts.sansSerif.name}:size=11";

        width = 35;
        tabs = 4;
        horizontal-pad = 0;
        vertical-pad = 0;
        inner-pad = 8;
        line-height = 20;
        fields = "filename,name,generic";
        layer = "overlay";
        exit-on-keyboard-focus-loss = "yes";
      };

      colors = {
        background = "${config.lib.stylix.colors.base01}ff";
        text = "${config.lib.stylix.colors.base06}ff";

        match = "${config.lib.stylix.colors.base0D}ff";

        selection = "${config.lib.stylix.colors.base02}ff";
        selection-text = "${config.lib.stylix.colors.base06}ff";
        selection-match = "${config.lib.stylix.colors.base0D}ff";

        border = "${config.lib.stylix.colors.base02}ff";
      };

      border = {
        width = 1;
        radius = 0;
      };
    };
  };
}
