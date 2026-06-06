{
  config,
  pkgs,
  lib,
  ...
}:
let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
in
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        spacing = 0;

        modules-left   = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "mpris" ];
        modules-right  = [
          "network"
          "cpu"
          "memory"
          "temperature"
          "pulseaudio"
          "clock"
        ];

        # left
        "niri/workspaces" = {
          format = "{index}";
        };

        "niri/window" = {
          max-length = 60;
        };

        # center
        mpris = {
          format = "  {artist} – {title}";
          format-paused = "  {artist} – {title}";
          max-length = 60;
          player-icons = { default = ""; };
          status-icons = { paused = ""; };
        };

        # right
        network = {
          interval = 1;
          format-ethernet = " ⇡ {bandwidthUpBytes} ⇣ {bandwidthDownBytes}";
          format-wifi     = " ⇡ {bandwidthUpBytes} ⇣ {bandwidthDownBytes}";
          format-disconnected = " disconnected";
          tooltip = false;
        };

        cpu = {
          interval = 1;
          format = "  {usage}%";
          tooltip = false;
        };

        memory = {
          interval = 1;
          format = "  {used:0.1f}/{total:0.1f} GiB";
          tooltip = false;
        };

        temperature = {
          interval = 5;
          format = " {icon}  {temperatureC}°C";
          format-icons = [ "" "" "" "" "" ];
          critical-threshold = 80;
        };

        pulseaudio = {
          format = " {icon}  {volume}%";
          format-muted = "  muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          scroll-step = 5;
        };

        clock = {
          interval = 60;
          format = "  {:%m/%d/%y %R}";
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: "${font}", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: #${c.base01};
        color: #${c.base06};
      }

      .modules-left > widget > *,
      .modules-center > widget > *,
      .modules-right > widget > * {
        padding: 0 8px;
        color: #${c.base06};
      }

      #workspaces button {
        padding: 0 6px;
        background: transparent;
        color: #${c.base04};
        border-bottom: 2px solid transparent;
      }
      #workspaces button.active {
        color: #${c.base06};
        border-bottom: 2px solid #${c.base09};
      }
      #workspaces button.urgent {
        color: #${c.base00};
        background: #${c.base08};
      }

      #cpu {
        color: #${c.base0B};
      }
      #memory {
        color: #${c.base0D};
      }
      #temperature {
        color: #${c.base0A};
      }
      #temperature.critical {
        color: #${c.base08};
      }
      #network {
        color: #${c.base0C};
      }
      #pulseaudio {
        color: #${c.base0E};
      }
      #clock {
        color: #${c.base06};
      }
      #mpris {
        color: #${c.base0D};
      }
    '';
  };

  home.packages = [ pkgs.pavucontrol ];
}
