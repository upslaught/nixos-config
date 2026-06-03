{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      blocks = [
        {
          block = "music";
        }
        {
          block = "net";
          format = " ⇡ $speed_up ⇣ $speed_down ";
          interval = 1;
        }
        {
          block = "cpu";
          format = " $icon  $utilization ";
          interval = 1;
        }
        {
          block = "memory";
          format = " $icon  $mem_used.eng(w:1)/$mem_total.eng(w:1) ";
          format_alt = " $icon  $mem_used_percents.eng(w:1) ";
          interval = 1;
        }
        {
          block = "weather";
          format = " $icon  $weather, $temp ";
          autolocate = true;
          service.name = "metno";
        }
        {
          block = "sound"; # that's fine for me
        }
        {
          block = "time";
          format = " $icon  $timestamp.datetime(f:'%m/%d/%y %R') ";
          interval = 60;
        }
      ];
      settings = {
        theme = {
          theme = "solarized-dark";
          overrides = {
            idle_bg = "#${config.lib.stylix.colors.base01}";
            idle_fg = "#${config.lib.stylix.colors.base06}";
            info_bg = "#${config.lib.stylix.colors.base0D}";
            info_fg = "#${config.lib.stylix.colors.base00}";
            good_bg = "#${config.lib.stylix.colors.base0B}";
            good_fg = "#${config.lib.stylix.colors.base00}";
            warning_bg = "#${config.lib.stylix.colors.base0A}";
            warning_fg = "#${config.lib.stylix.colors.base00}";
            critical_bg = "#${config.lib.stylix.colors.base08}";
            critical_fg = "#${config.lib.stylix.colors.base00}";
            separator = " ";
          };
        };
        icons.icons = "material-nf";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      window = {
        border = 1;
      };

      startup = [
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";}
      ];

      colors = lib.mkForce {
        focused = {
          border = "#${config.lib.stylix.colors.base02}";
          background = "#${config.lib.stylix.colors.base02}";
          text = "#${config.lib.stylix.colors.base06}";
          indicator = "#${config.lib.stylix.colors.base02}";
          childBorder = "#${config.lib.stylix.colors.base02}";
        };
        focusedInactive = {
          border = "#${config.lib.stylix.colors.base02}";
          background = "#${config.lib.stylix.colors.base01}";
          text = "#${config.lib.stylix.colors.base06}";
          indicator = "#${config.lib.stylix.colors.base02}";
          childBorder = "#${config.lib.stylix.colors.base02}";
        };
        unfocused = {
          border = "#${config.lib.stylix.colors.base02}";
          background = "#${config.lib.stylix.colors.base01}";
          text = "#${config.lib.stylix.colors.base04}";
          indicator = "#${config.lib.stylix.colors.base02}";
          childBorder = "#${config.lib.stylix.colors.base02}";
        };
        urgent = {
          border = "#${config.lib.stylix.colors.base08}";
          background = "#${config.lib.stylix.colors.base08}";
          text = "#${config.lib.stylix.colors.base00}";
          indicator = "#${config.lib.stylix.colors.base08}";
          childBorder = "#${config.lib.stylix.colors.base08}";
        };
      };

      bars = [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [config.stylix.fonts.sansSerif.name config.stylix.fonts.monospace.name];
            size = 10.0;
          };
          position = "top";
          colors = {
            background = "#${config.lib.stylix.colors.base01}";
            statusline = "#${config.lib.stylix.colors.base06}";
            separator = "#${config.lib.stylix.colors.base02}";
            focusedWorkspace = {
              border = "#${config.lib.stylix.colors.base09}";
              background = "#${config.lib.stylix.colors.base02}";
              text = "#${config.lib.stylix.colors.base06}";
            };
            activeWorkspace = {
              border = "#${config.lib.stylix.colors.base02}";
              background = "#${config.lib.stylix.colors.base01}";
              text = "#${config.lib.stylix.colors.base06}";
            };
            inactiveWorkspace = {
              border = "#${config.lib.stylix.colors.base01}";
              background = "#${config.lib.stylix.colors.base01}";
              text = "#${config.lib.stylix.colors.base06}";
            };
            urgentWorkspace = {
              border = "#${config.lib.stylix.colors.base08}";
              background = "#${config.lib.stylix.colors.base08}";
              text = "#${config.lib.stylix.colors.base01}";
            };
          };
        }
      ];

      modifier = "Mod4";
      keybindings = lib.mkOptionDefault {
        # programs
        "${modifier}+w" = "exec ${pkgs.brave}/bin/brave"; # [w]eb browser
        "${modifier}+d" = "exec ${pkgs.fuzzel}/bin/fuzzel"; # [d]run (???)
        "${modifier}+Shift+s" = "exec mkdir -p ~/Pictures/Screenshots && selection=$(${pkgs.slurp}/bin/slurp) && ${pkgs.grim}/bin/grim -g \"$selection\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
        "${modifier}+v" = "exec ${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel -d | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"; # it's like that on windows

        # brightness
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -U 10";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -A 10";

        # volume
        "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # audio
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
      };

      output."DP-1" = {
        mode = "1920x1080@179.998Hz";
      };

      input."*" = {
        xkb_variant = "us";
        repeat_delay = "200";
        repeat_rate = "40";
      };
    };
  };
}
