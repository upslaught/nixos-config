{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";

      keybindings = lib.mkOptionDefault {
        "${modifier}+w" = "exec ${pkgs.brave}/bin/brave"; # [w]eb browser
        "${modifier}+d" = "exec ${pkgs.fuzzel}/bin/fuzzel"; # [d]run (???)
        "${modifier}+Shift+s" = "exec selection=$(slurp) && grim -g \"$selection\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
      };

      input = {
        "*" = {
          xkb_variant = "us";
          repeat_delay = "200";
          repeat_rate = "40";
        };
      };

      output."DP-1" = {
        mode = "1920x1080@179.998Hz"; # where did my other .002 hz go :C
      };
    };
  };
}
