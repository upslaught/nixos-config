{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.config
  ];

  programs.niri = {
    settings = {
      prefer-no-csd = true;

      outputs."DP-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 179.998;
        };
      };

      input = {
        keyboard = {
          xkb.layout = "us";
          repeat-delay = 200;
          repeat-rate = 40;
        };
      };

      spawn-at-startup = [
        { command = [ "${pkgs.wl-clipboard}/bin/wl-paste" "--watch" "${pkgs.cliphist}/bin/cliphist" "store" ]; }
        { command = [ "${pkgs.waybar}/bin/waybar" ]; }
        { command = [ "${pkgs.mako}/bin/mako" ]; }
      ];

      layout = {
        gaps = 8;
        border = {
          enable = true;
          width = 1;
          active.color = "#${config.lib.stylix.colors.base0D}ff";
          inactive.color = "#${config.lib.stylix.colors.base02}ff";
        };
        focus-ring.enable = false;
      };

      cursor = {
        theme = config.stylix.cursor.name;
        size = config.stylix.cursor.size;
      };

      binds = with config.lib.niri.actions; let
        sh = cmd: spawn "sh" "-c" cmd;
      in {
        "Mod+Return".action = spawn "${pkgs.foot}/bin/foot";
        "Mod+B".action      = spawn "${pkgs.brave}/bin/brave";
        "Mod+D".action      = spawn "${pkgs.fuzzel}/bin/fuzzel";

        "Mod+V".action = sh
          "${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel -d | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";

        "Mod+Shift+S".action = sh
          "mkdir -p ~/Pictures/Screenshots && selection=$(${pkgs.slurp}/bin/slurp) && ${pkgs.grim}/bin/grim -g \"$selection\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";

        "XF86MonBrightnessDown".action = sh "${pkgs.brightnessctl}/bin/brightnessctl -U 10";
        "XF86MonBrightnessUp".action   = sh "${pkgs.brightnessctl}/bin/brightnessctl -A 10";

        "XF86AudioRaiseVolume".action = sh "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume".action = sh "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute".action        = sh "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        "XF86AudioPlay".action = spawn "${pkgs.playerctl}/bin/playerctl" "play-pause";
        "XF86AudioNext".action = spawn "${pkgs.playerctl}/bin/playerctl" "next";
        "XF86AudioPrev".action = spawn "${pkgs.playerctl}/bin/playerctl" "previous";

        "Mod+Q".action         = close-window;
        "Mod+H".action         = focus-column-left;
        "Mod+L".action         = focus-column-right;
        "Mod+J".action         = focus-window-down;
        "Mod+K".action         = focus-window-up;
        "Mod+Shift+H".action   = move-column-left;
        "Mod+Shift+L".action   = move-column-right;
        "Mod+Shift+J".action   = move-window-down;
        "Mod+Shift+K".action   = move-window-up;
        "Mod+F".action         = maximize-column;
        "Mod+Shift+F".action   = fullscreen-window;
        "Mod+Minus".action     = set-column-width "-10%";
        "Mod+Equal".action     = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+Shift+1".action = move-window-to-workspace 1;
        "Mod+Shift+2".action = move-window-to-workspace 2;
        "Mod+Shift+3".action = move-window-to-workspace 3;
        "Mod+Shift+4".action = move-window-to-workspace 4;
        "Mod+Shift+5".action = move-window-to-workspace 5;

        "Mod+Tab".action = focus-workspace-previous;

        "Mod+Shift+E".action = quit;
        "Mod+Shift+R".action = reload-config;
      };
    };
  };

  home.packages = with pkgs; [
    grim
    slurp
    cliphist
    brightnessctl
    playerctl
    wireplumber
  ];
}
