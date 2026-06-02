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
        # programs
        "${modifier}+w" = "exec ${pkgs.brave}/bin/brave"; # [w]eb browser
        "${modifier}+d" = "exec ${pkgs.fuzzel}/bin/fuzzel"; # [d]run (???)
        "${modifier}+Shift+s" = "exec selection=$(${pkgs.slurp}/bin/slurp) && ${pkgs.grim}/grim -g \"$selection\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | ${pkgs.wl-clipboard}/bin/wl-copy";

        # brightness
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -U 10";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -A 10";

        # volume
        "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-sink-volume @DEFAULT_SINK@ +1%";
        "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-sink-mute @DEFAULT_SINK@ toggle";
      };

      # is there a way to do this per-host?
      output."DP-1" = {
        mode = "1920x1080@179.998Hz"; # where did my other .002 hz go :C
      };

      input."*" = {
        xkb_variant = "us";
        repeat_delay = "200";
        repeat_rate = "40";
      };
    };
  };
}
